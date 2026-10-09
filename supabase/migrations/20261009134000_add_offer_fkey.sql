alter table public.offers 
  add constraint offers_doctor_id_fkey foreign key (doctor_id) references public.doctors(doctor_id) on delete cascade;
alter table public.offers 
  add constraint offers_clinic_id_fkey foreign key (clinic_id) references public.clinic_data(id) on delete cascade;
