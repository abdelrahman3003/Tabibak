-- Create notifications table for in-app notification inbox + FCM history
create table if not exists public.notifications (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  title text not null,
  body text not null,
  type text not null default 'general'
    check (type in ('appointment', 'reminder', 'cancellation', 'result', 'promotion', 'general')),
  data jsonb not null default '{}'::jsonb,
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);

create index if not exists notifications_user_created_idx
  on public.notifications (user_id, created_at desc);

create index if not exists notifications_user_unread_idx
  on public.notifications (user_id, is_read, created_at desc)
  where is_read = false;

alter table public.notifications enable row level security;

-- Authenticated users can only read their own notifications
drop policy if exists "Users can read own notifications" on public.notifications;
create policy "Users can read own notifications"
  on public.notifications for select
  to authenticated
  using ((select auth.uid()) = user_id);

-- Users can mark own notifications as read / update own rows
drop policy if exists "Users can update own notifications" on public.notifications;
create policy "Users can update own notifications"
  on public.notifications for update
  to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

-- Users can delete own notifications
drop policy if exists "Users can delete own notifications" on public.notifications;
create policy "Users can delete own notifications"
  on public.notifications for delete
  to authenticated
  using ((select auth.uid()) = user_id);

-- Inserts go through service_role (edge functions). Allow authenticated insert
-- of own rows as well so optimistic client inserts work if needed.
drop policy if exists "Users can insert own notifications" on public.notifications;
create policy "Users can insert own notifications"
  on public.notifications for insert
  to authenticated
  with check ((select auth.uid()) = user_id);

-- Expose to Data API roles (required when Data API has restrictive defaults)
grant select, insert, update, delete on public.notifications to authenticated;
grant select, insert, update, delete on public.notifications to service_role;
grant usage, select on sequence public.notifications_id_seq to authenticated, service_role;

-- Enable realtime so the app inbox updates live (idempotent).
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'notifications'
  ) then
    alter publication supabase_realtime add table public.notifications;
  end if;
end $$;
