-- notifications.user_id references public.users(user_id). Ensure existing
-- doctor auth accounts also have a recipient profile for the inbox.
insert into public.users (user_id, name, email, image, is_doctor)
select d.doctor_id, d.name, d.email, d.image, true
from public.doctors d
join auth.users a on a.id = d.doctor_id
on conflict (user_id) do nothing;
