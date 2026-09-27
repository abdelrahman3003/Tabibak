-- Device records are for notification delivery; they must not restrict auth.
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

  -- Serialize registrations for one account and reuse a slot when an
  -- existing installation reports its same FCM token under a new device ID.
  perform pg_catalog.pg_advisory_xact_lock(
    pg_catalog.hashtextextended(v_user_id::text, 0)
  );

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

revoke all on function public.register_my_device(text, text, text) from public, anon;
grant execute on function public.register_my_device(text, text, text) to authenticated, service_role;
