-- Normalize location data.  The legacy city table mixed three different
-- entities and allowed denormalized/contradictory address rows.
create table if not exists public.governorates (
  id bigint primary key,
  name_ar text not null,
  name_en text,
  created_at timestamptz not null default now(),
  unique (name_ar)
);

create table if not exists public.markaz (
  id bigint primary key,
  governorate_id bigint not null references public.governorates(id) on delete restrict,
  name_ar text not null,
  name_en text,
  created_at timestamptz not null default now(),
  unique (governorate_id, name_ar)
);

create table if not exists public.villages (
  id bigint primary key,
  markaz_id bigint not null references public.markaz(id) on delete restrict,
  name_ar text not null,
  name_en text,
  created_at timestamptz not null default now(),
  unique (markaz_id, name_ar)
);

-- Preserve legacy IDs so existing API payloads and address references remain stable.
insert into public.governorates (id, name_ar, name_en)
select id, coalesce(nullif(name_ar, ''), name_en, 'Governorate ' || id), name_en
from public.city where type = 'governorate'
on conflict (id) do update set name_ar = excluded.name_ar, name_en = excluded.name_en;
insert into public.governorates (id, name_ar, name_en)
select id, coalesce(nullif(name_ar, ''), name_en, 'Governorate ' || id), name_en
from public.governorate
on conflict (id) do update set name_ar = excluded.name_ar, name_en = excluded.name_en;

insert into public.markaz (id, governorate_id, name_ar, name_en)
select c.id,
       coalesce(c.governorate_id, p.governorate_id, p.parent_id),
       coalesce(nullif(c.name_ar, ''), c.name_en, 'Markaz ' || c.id), c.name_en
from public.city c
left join public.city p on p.id = c.parent_id
where c.type = 'markaz'
  and coalesce(c.governorate_id, p.governorate_id, p.parent_id) in (select id from public.governorates)
on conflict (id) do update set governorate_id = excluded.governorate_id,
  name_ar = excluded.name_ar, name_en = excluded.name_en;

insert into public.villages (id, markaz_id, name_ar, name_en)
select c.id, c.parent_id,
       coalesce(nullif(c.name_ar, ''), c.name_en, 'Village ' || c.id), c.name_en
from public.city c
where c.type = 'village' and c.parent_id in (select id from public.markaz)
on conflict (id) do update set markaz_id = excluded.markaz_id,
  name_ar = excluded.name_ar, name_en = excluded.name_en;

create table if not exists public.user_addresses (
  user_id uuid primary key references auth.users(id) on delete cascade,
  governorate_id bigint references public.governorates(id) on delete restrict,
  markaz_id bigint references public.markaz(id) on delete restrict,
  village_id bigint references public.villages(id) on delete restrict,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (governorate_id is not null or markaz_id is not null or village_id is not null)
);

insert into public.user_addresses (user_id, governorate_id, markaz_id, village_id)
select u.user_id,
       case when vg.type = 'governorate' then vg.id else coalesce(vg.governorate_id, mg.governorate_id) end,
       case when m.type = 'markaz' then m.id else coalesce(m.id, m2.id) end,
       case when v.type = 'village' then v.id end
from public.users u
left join public.city vg on vg.id = u.city_id
left join public.city m on m.id = u.district_id
left join public.city v on v.id = u.village_id
left join public.markaz mg on mg.id = m.id
left join public.markaz m2 on m2.id = vg.id
where (case when vg.type = 'governorate' then vg.id else coalesce(vg.governorate_id, mg.governorate_id) end) is not null
   or (case when m.type = 'markaz' then m.id else coalesce(m.id, m2.id) end) is not null
   or (case when v.type = 'village' then v.id end) is not null
on conflict (user_id) do update set governorate_id = excluded.governorate_id,
  markaz_id = excluded.markaz_id, village_id = excluded.village_id;

-- Convert clinic addresses to one canonical path. A clinic address stores the
-- village only; its markaz and governorate are derived through foreign keys.
alter table public.clinic_address add column if not exists address_village_id bigint;
alter table public.clinic_address add column if not exists legacy_markaz_id bigint;
update public.clinic_address set address_village_id = village_id;
update public.clinic_address set legacy_markaz_id = markaz_id;
update public.clinic_address set address_village_id = markaz_id
where address_village_id is null and markaz_id in (select id from public.villages);
update public.clinic_address set address_village_id = null
where address_village_id is not null and address_village_id not in (select id from public.villages);
alter table public.clinic_address drop constraint if exists clinic_address_village_id_fkey;
alter table public.clinic_address drop constraint if exists clinic_address_markaz_id_fkey;
alter table public.clinic_address drop constraint if exists clinic_address_governorate_id_fkey;
alter table public.clinic_address drop constraint if exists clinic_address_city_id_fkey;
alter table public.clinic_address add constraint clinic_address_village_fk
  foreign key (address_village_id) references public.villages(id) on delete restrict;
alter table public.clinic_address drop column if exists city_id;
alter table public.clinic_address drop column if exists markaz_id;
alter table public.clinic_address drop column if exists governorate_id;
alter table public.clinic_address drop column if exists village_id;
alter table public.clinic_address rename column address_village_id to village_id;
alter table public.clinic_address drop column if exists markaz;
alter table public.clinic_address add column if not exists markaz_id bigint;
alter table public.clinic_address add column if not exists governorate_id bigint;
update public.clinic_address ca
set markaz_id = v.markaz_id, governorate_id = m.governorate_id
from public.villages v join public.markaz m on m.id = v.markaz_id
where ca.village_id = v.id;
update public.clinic_address ca
set markaz_id = lm.id, governorate_id = lm.governorate_id
from public.markaz lm
where ca.markaz_id is null and ca.legacy_markaz_id = lm.id;
alter table public.clinic_address drop column if exists legacy_markaz_id;
alter table public.clinic_address add constraint clinic_address_markaz_fk
  foreign key (markaz_id) references public.markaz(id) on delete restrict;
alter table public.clinic_address add constraint clinic_address_governorate_fk
  foreign key (governorate_id) references public.governorates(id) on delete restrict;

alter table public.users drop constraint if exists users_city_id_fkey;
alter table public.users drop column if exists city_id;
alter table public.users drop column if exists district_id;
alter table public.users drop column if exists village_id;
alter table public.doctors drop constraint if exists doctors_markaz_id_fkey;
alter table public.doctors drop column if exists markaz_id;
alter table public.doctors drop column if exists markaz;

drop table if exists public.city cascade;
drop table if exists public.governorate cascade;

create index if not exists markaz_governorate_idx on public.markaz(governorate_id);
create index if not exists villages_markaz_idx on public.villages(markaz_id);
create index if not exists clinic_address_village_idx on public.clinic_address(village_id);

alter table public.governorates enable row level security;
alter table public.markaz enable row level security;
alter table public.villages enable row level security;
alter table public.user_addresses enable row level security;
create policy governorates_read on public.governorates for select to anon, authenticated using (true);
create policy markaz_read on public.markaz for select to anon, authenticated using (true);
create policy villages_read on public.villages for select to anon, authenticated using (true);
create policy user_addresses_owner on public.user_addresses for all to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);

create or replace function public.get_markazes(p_governorate_id bigint)
returns setof public.markaz language sql stable as $$
  select * from public.markaz where governorate_id = p_governorate_id order by name_ar;
$$;
create or replace function public.get_villages(p_markaz_id bigint)
returns setof public.villages language sql stable as $$
  select * from public.villages where markaz_id = p_markaz_id order by name_ar;
$$;

-- Compatibility RPC names now use explicit parent filtering and never inspect doctors.
create or replace function public.get_markazes_with_doctors(p_governorate_id bigint default null)
returns setof public.markaz language sql stable as $$
  select m.* from public.markaz m where p_governorate_id is null or m.governorate_id = p_governorate_id order by m.name_ar;
$$;
create or replace function public.get_villages_with_doctors(p_markaz_id bigint)
returns setof public.villages language sql stable as $$
  select v.* from public.villages v where v.markaz_id = p_markaz_id order by v.name_ar;
$$;

drop function if exists public.add_clinic_for_doctor(uuid,text,text,integer,boolean,boolean,bigint,bigint,text,text,text,jsonb);
create or replace function public.add_clinic_for_doctor(
  p_doctor_id uuid, p_clinic_name text, p_phone_number text default null,
  p_consultation_fee integer default 0, p_is_booking boolean default false,
  p_is_available boolean default true, p_markaz_id bigint default null,
  p_village_id bigint default null, p_street text default null,
  p_floor text default null, p_department text default null,
  p_working_days jsonb default null
) returns jsonb language plpgsql security definer set search_path = public as $$
declare c public.clinic_data%rowtype; a public.clinic_address%rowtype; d jsonb;
begin
  if not exists (select 1 from public.doctors where doctor_id = p_doctor_id) then
    raise exception 'Doctor not found';
  end if;
  if p_village_id is not null and not exists
    (select 1 from public.villages where id = p_village_id and (p_markaz_id is null or markaz_id = p_markaz_id)) then
    raise exception 'Village does not belong to the selected markaz';
  end if;
  insert into public.clinic_data(doctor_id,clinic_name,phone_number,consultation_fee,is_booking,is_available)
  values(p_doctor_id,p_clinic_name,p_phone_number,coalesce(p_consultation_fee,0),coalesce(p_is_booking,false),coalesce(p_is_available,true)) returning * into c;
  if p_markaz_id is not null or p_village_id is not null then
    insert into public.clinic_address(clinic_id,governorate_id,markaz_id,village_id,street,floor,department)
    select c.id, m.governorate_id, coalesce(p_markaz_id,v.markaz_id), p_village_id,p_street,p_floor,p_department
    from public.markaz m left join public.villages v on v.id=p_village_id
    where m.id=coalesce(p_markaz_id,v.markaz_id) returning * into a;
  end if;
  return jsonb_build_object('clinic',to_jsonb(c),'address',to_jsonb(a));
end; $$;
revoke all on function public.add_clinic_for_doctor(uuid,text,text,integer,boolean,boolean,bigint,bigint,text,text,text,jsonb) from public, anon;
grant execute on function public.add_clinic_for_doctor(uuid,text,text,integer,boolean,boolean,bigint,bigint,text,text,text,jsonb) to authenticated, service_role;

notify pgrst, 'reload schema';
