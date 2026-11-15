-- Corrie Fay: two-member shared favorites
-- Execute in Supabase SQL Editor after creating the project.
create table if not exists public.members (
 user_id uuid primary key references auth.users(id) on delete cascade
);
create table if not exists public.favorites (
 event_id text primary key,
 saved_by uuid not null references auth.users(id),
 saved_at timestamptz not null default now()
);
alter table public.members enable row level security;
alter table public.favorites enable row level security;
revoke all on public.members from anon, authenticated;
grant select, insert, delete on public.favorites to authenticated;
drop policy if exists "members read favorites" on public.favorites;
drop policy if exists "members add favorites" on public.favorites;
drop policy if exists "members delete favorites" on public.favorites;
create policy "members read favorites" on public.favorites for select to authenticated
using (exists(select 1 from public.members m where m.user_id=(select auth.uid())));
create policy "members add favorites" on public.favorites for insert to authenticated
with check (saved_by=(select auth.uid()) and exists(select 1 from public.members m where m.user_id=(select auth.uid())));
create policy "members delete favorites" on public.favorites for delete to authenticated
using (exists(select 1 from public.members m where m.user_id=(select auth.uid())));
-- No client-facing policy or grants for members: only project admins add members.
-- After each user signs in, run in SQL Editor with their exact email:
-- insert into public.members(user_id)
-- select id from auth.users where email = 'REPLACE_WITH_MEMBER_EMAIL'
-- on conflict do nothing;
