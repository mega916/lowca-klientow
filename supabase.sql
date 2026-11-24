-- Wklej w Supabase: SQL Editor -> New query -> Run
create table if not exists public.app_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  icp jsonb not null default '{}'::jsonb,
  leads jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.app_data enable row level security;
create policy "own select" on public.app_data for select using (auth.uid() = user_id);
create policy "own insert" on public.app_data for insert with check (auth.uid() = user_id);
create policy "own update" on public.app_data for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- dostęp do API tylko dla zalogowanych (potrzebne, gdy nowe tabele nie są udostępniane automatycznie)
grant usage on schema public to authenticated;
grant select, insert, update on public.app_data to authenticated;
