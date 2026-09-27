alter table public.doctors
  add column if not exists visits_count integer not null default 0;

create index if not exists appointments_doctor_status_idx
  on public.appointments (doctor_id, status);

create schema if not exists private;
revoke all on schema private from public, anon, authenticated;

create or replace function private.sync_doctor_completed_visits_count()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if tg_op = 'INSERT' then
    if new.status = 3 then
      update public.doctors
         set visits_count = visits_count + 1
       where doctor_id = new.doctor_id;
    end if;
    return new;
  elsif tg_op = 'DELETE' then
    if old.status = 3 then
      update public.doctors
         set visits_count = greatest(visits_count - 1, 0)
       where doctor_id = old.doctor_id;
    end if;
    return old;
  end if;

  if old.doctor_id is distinct from new.doctor_id then
    if old.status = 3 then
      update public.doctors
         set visits_count = greatest(visits_count - 1, 0)
       where doctor_id = old.doctor_id;
    end if;
    if new.status = 3 then
      update public.doctors
         set visits_count = visits_count + 1
       where doctor_id = new.doctor_id;
    end if;
  elsif old.status is distinct from new.status then
    if new.status = 3 then
      update public.doctors
         set visits_count = visits_count + 1
       where doctor_id = new.doctor_id;
    elsif old.status = 3 then
      update public.doctors
         set visits_count = greatest(visits_count - 1, 0)
       where doctor_id = old.doctor_id;
    end if;
  end if;

  return new;
end;
$$;

revoke all on function private.sync_doctor_completed_visits_count()
  from public, anon, authenticated;

drop trigger if exists sync_doctor_completed_visits_count
  on public.appointments;
create trigger sync_doctor_completed_visits_count
after insert or update of status, doctor_id or delete
on public.appointments
for each row
execute function private.sync_doctor_completed_visits_count();

update public.doctors as doctor
   set visits_count = (
     select count(*)::integer
       from public.appointments as appointment
      where appointment.doctor_id = doctor.doctor_id
        and appointment.status = 3
   );
