create table if not exists public.offers (
  id bigint generated always as identity primary key,
  title_en text,
  title_ar text,
  details_en text,
  details_ar text,
  discount numeric,
  start_date timestamptz,
  end_date timestamptz,
  doctor_id uuid,
  clinic_id bigint,
  is_active boolean default true,
  created_at timestamptz not null default now()
);

alter table public.offers enable row level security;

create policy "Offers are viewable by everyone"
  on public.offers for select
  to public
  using (true);

create policy "Doctors can insert their own offers"
  on public.offers for insert
  to authenticated
  with check (auth.uid() = doctor_id);

create policy "Doctors can update their own offers"
  on public.offers for update
  to authenticated
  using (auth.uid() = doctor_id)
  with check (auth.uid() = doctor_id);

create policy "Doctors can delete their own offers"
  on public.offers for delete
  to authenticated
  using (auth.uid() = doctor_id);

grant select, insert, update, delete on public.offers to authenticated;
grant select, insert, update, delete on public.offers to service_role;
grant select on public.offers to anon;
