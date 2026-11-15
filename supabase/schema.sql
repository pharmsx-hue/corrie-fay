-- Corrie Fay: shared favorites backend (Supabase)
-- Run only after configuring authentication for the two intended users.
create table if not exists public.favorites (
  event_id text primary key,
  saved_by uuid not null references auth.users(id),
  saved_at timestamptz not null default now()
);
alter table public.favorites enable row level security;
-- No policies yet: default deny for anon and authenticated users.
-- A secure two-person membership policy will be added after choosing authentication.
