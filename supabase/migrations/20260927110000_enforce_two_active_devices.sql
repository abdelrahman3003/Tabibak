-- Track signed-in app installs and cap each account at two active devices.
create table if not exists public.user_devices (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  device_id text not null,
  fcm_token text,
  platform text not null check (platform in ('android', 'ios', 'other')),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  last_seen_at timestamptz not null default now(),
  unique (user_id, device_id)
);

create index if not exists user_devices_active_user_idx
  on public.user_devices (user_id, last_seen_at desc)
  where is_active;

alter table public.user_devices enable row level security;
grant select, insert, update, delete on public.user_devices to service_role;

create or replace function public.register_my_device(
  p_device_id text,
  p_fcm_token text,
  p_platform text
)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := auth.uid();
  v_active_count bigint;
  v_existing_device_id text;
begin
  if v_user_id is null then
    raise exception 'Authentication required' using errcode = '42501';
  end if;

  if nullif(pg_catalog.btrim(p_device_id), '') is null
     or (p_platform is distinct from 'android'
         and p_platform is distinct from 'ios'
         and p_platform is distinct from 'other') then
    raise exception 'Invalid device registration';
  end if;

  -- Serialize by account so concurrent sign-ins cannot both claim the last slot.
  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(v_user_id::text, 0)
  );

  -- Preserve the existing device slot when upgrading an install that already
  -- registered this FCM token under an older device ID.
  if p_fcm_token is not null
     and not exists (
       select 1 from public.user_devices
       where user_id = v_user_id and device_id = p_device_id
     ) then
    select device_id
    into v_existing_device_id
    from public.user_devices
    where user_id = v_user_id
      and is_active
      and fcm_token = p_fcm_token
    order by last_seen_at desc
    limit 1;

    if v_existing_device_id is not null then
      update public.user_devices
      set device_id = p_device_id,
          platform = p_platform,
          last_seen_at = pg_catalog.now()
      where user_id = v_user_id
        and device_id = v_existing_device_id;
      return true;
    end if;
  end if;

  select pg_catalog.count(*)
  into v_active_count
  from public.user_devices
  where user_id = v_user_id
    and is_active
    and device_id <> p_device_id;

  if v_active_count >= 2 then
    return false;
  end if;

  insert into public.user_devices (user_id, device_id, fcm_token, platform)
  values (v_user_id, p_device_id, p_fcm_token, p_platform)
  on conflict (user_id, device_id) do update
    set fcm_token = excluded.fcm_token,
        platform = excluded.platform,
        is_active = true,
        last_seen_at = pg_catalog.now();

  return true;
end;
$$;

create or replace function public.unregister_my_device(p_device_id text)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := auth.uid();
begin
  if v_user_id is null then
    raise exception 'Authentication required' using errcode = '42501';
  end if;

  update public.user_devices
  set is_active = false,
      last_seen_at = pg_catalog.now()
  where user_id = v_user_id
    and device_id = p_device_id;
end;
$$;

revoke all on function public.register_my_device(text, text, text) from public, anon;
revoke all on function public.unregister_my_device(text) from public, anon;
grant execute on function public.register_my_device(text, text, text) to authenticated, service_role;
grant execute on function public.unregister_my_device(text) to authenticated, service_role;
