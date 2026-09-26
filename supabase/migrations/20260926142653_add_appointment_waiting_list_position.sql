create or replace function public.add_appointment_with_waiting_list(
  p_appointment_date date,
  p_doctor_id uuid,
  p_user_id uuid,
  p_status integer,
  p_phone text,
  p_name text,
  p_description text,
  p_shift_morning_id integer,
  p_shift_evening_id integer,
  p_appointment_type integer
)
returns setof public.appointments
language plpgsql
set search_path = public
as $$
declare
  next_waiting_list integer;
begin
  -- Serialize number assignment for a doctor and appointment date.
  perform pg_advisory_xact_lock(
    hashtextextended(p_doctor_id::text || ':' || p_appointment_date::text, 0)
  );

  select coalesce(max(waiting_list), 0) + 1
    into next_waiting_list
    from public.appointments
   where doctor_id = p_doctor_id
     and appointment_date = p_appointment_date;

  return query
  insert into public.appointments (
    appointment_date,
    doctor_id,
    user_id,
    status,
    phone,
    name,
    description,
    appointment_morning_shift_id,
    appointment_evening_shift_id,
    appointment_type,
    waiting_list
  ) values (
    p_appointment_date,
    p_doctor_id,
    p_user_id,
    p_status,
    p_phone,
    p_name,
    p_description,
    p_shift_morning_id,
    p_shift_evening_id,
    p_appointment_type,
    next_waiting_list
  )
  returning *;
end;
$$;

revoke all on function public.add_appointment_with_waiting_list(
  date, uuid, uuid, integer, text, text, text, integer, integer, integer
) from public, anon, authenticated;

grant execute on function public.add_appointment_with_waiting_list(
  date, uuid, uuid, integer, text, text, text, integer, integer, integer
) to service_role;
