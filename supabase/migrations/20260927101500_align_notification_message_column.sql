-- The live notification contract and Flutter NotificationModel use `message`.
-- Earlier installations created `body`; rename it on fresh/older databases.
do $$
begin
  if exists (
    select 1 from information_schema.columns
    where table_schema = 'public'
      and table_name = 'notifications'
      and column_name = 'body'
  ) and not exists (
    select 1 from information_schema.columns
    where table_schema = 'public'
      and table_name = 'notifications'
      and column_name = 'message'
  ) then
    alter table public.notifications rename column body to message;
  elsif exists (
    select 1 from information_schema.columns
    where table_schema = 'public'
      and table_name = 'notifications'
      and column_name = 'body'
  ) and exists (
    select 1 from information_schema.columns
    where table_schema = 'public'
      and table_name = 'notifications'
      and column_name = 'message'
  ) then
    update public.notifications
    set message = coalesce(message, body)
    where message is null;
  end if;
end $$;
