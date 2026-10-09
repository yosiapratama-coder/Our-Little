-- Replace sample addresses below with the exact uploader Google emails.
-- Create a PUBLIC bucket named memories first (or run this SQL to configure it).
insert into storage.buckets (id,name,public,file_size_limit,allowed_mime_types)
values ('memories','memories',true,8388608,array['image/jpeg','image/png','image/webp','image/gif'])
on conflict(id) do update set public=true,file_size_limit=8388608,allowed_mime_types=array['image/jpeg','image/png','image/webp','image/gif'];
drop policy if exists "Public can list and view memories" on storage.objects;
create policy "Public can list and view memories" on storage.objects for select to anon,authenticated using(bucket_id='memories');
drop policy if exists "Allowlisted Google users can upload memories" on storage.objects;
create policy "Allowlisted Google users can upload memories" on storage.objects for insert to authenticated with check (
 bucket_id='memories'
 and lower(coalesce(auth.jwt()->>'email','')) in ('your-email@gmail.com','partner-email@gmail.com')
 and lower(coalesce(auth.jwt()->>'email','')) <> ''
);
-- No UPDATE or DELETE policy: browser users cannot overwrite or delete files.
