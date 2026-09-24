-- Supabase SQL Editor에서 한 번 실행
create table if not exists public.onepick_shared_books (
  shared_key text primary key,
  name text not null default '',
  file_name text not null default '',
  book_json jsonb not null default '{}'::jsonb,
  questions_json jsonb not null default '[]'::jsonb,
  view_adjustments_json jsonb not null default '{}'::jsonb,
  pdf_path text,
  updated_at timestamptz not null default now()
);

alter table public.onepick_shared_books enable row level security;

drop policy if exists "onepick shared books public read" on public.onepick_shared_books;
create policy "onepick shared books public read" on public.onepick_shared_books for select to anon, authenticated using (true);

drop policy if exists "onepick shared books authenticated write" on public.onepick_shared_books;
create policy "onepick shared books authenticated write" on public.onepick_shared_books for all to authenticated using (true) with check (true);

insert into storage.buckets (id,name,public) values ('onepick-pdfs','onepick-pdfs',true) on conflict (id) do update set public=true;

drop policy if exists "onepick pdf public read" on storage.objects;
create policy "onepick pdf public read" on storage.objects for select to anon, authenticated using (bucket_id='onepick-pdfs');

drop policy if exists "onepick pdf authenticated insert" on storage.objects;
create policy "onepick pdf authenticated insert" on storage.objects for insert to authenticated with check (bucket_id='onepick-pdfs');

drop policy if exists "onepick pdf authenticated update" on storage.objects;
create policy "onepick pdf authenticated update" on storage.objects for update to authenticated using (bucket_id='onepick-pdfs') with check (bucket_id='onepick-pdfs');

drop policy if exists "onepick pdf authenticated delete" on storage.objects;
create policy "onepick pdf authenticated delete" on storage.objects for delete to authenticated using (bucket_id='onepick-pdfs');
