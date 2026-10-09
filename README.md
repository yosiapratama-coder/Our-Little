# Our Little Photobooth — Supabase edition

Versi ini tidak menggunakan Firebase Cloud Storage dan tidak memerlukan Firebase Blaze untuk menyimpan foto. Foto tersimpan di Supabase Storage; Firebase Hosting hanya dipakai untuk menyajikan file website statis. Kuota dan harga Supabase dapat berubah, periksa halaman Usage/Pricing sebelum dipakai luas.

## 1. Buat project Supabase
1. Buka https://supabase.com/ dan buat project.
2. Di Project Settings > API (atau Connect/API Keys), salin **Project URL** dan **publishable key** atau legacy **anon key**.
3. Jangan gunakan `service_role` atau secret key di browser.
4. Buka `app.js` dan ganti `SUPABASE_URL` serta `SUPABASE_ANON_KEY`.
5. Ganti alamat email contoh dalam `ALLOWED_UPLOADER_EMAILS` dengan email Google uploader.

## 2. Aktifkan Google login
1. Supabase Dashboard > Authentication > Sign In / Providers > Google > Enable.
2. Ikuti instruksi Supabase untuk membuat Google OAuth Client ID/Secret pada Google Cloud Console > APIs & Services > Credentials.
3. Masukkan callback URL yang ditampilkan Supabase sebagai Authorized redirect URI di Google Cloud, lalu isi Client ID/Secret pada provider Google di Supabase.
4. Supabase > Authentication > URL Configuration: atur Site URL ke URL website nanti dan tambahkan redirect URLs untuk preview/local dan website publik, misalnya `http://localhost:5000/**` dan `https://PROJECT_ID.web.app/**`.
5. Jika layar persetujuan OAuth Google masih berstatus Testing, tambahkan email uploader sebagai test users.

## 3. Buat bucket dan aturan keamanan
1. Supabase > Storage > New bucket, nama persis `memories`, aktifkan **Public bucket**. Batas file 8 MB dan MIME types JPEG/PNG/WebP/GIF jika pengaturan tersedia.
2. Buka SQL Editor > New query. Di `storage-policies.sql`, ganti kedua email contoh dengan email uploader yang sama dengan `app.js`, lalu jalankan seluruh SQL.
3. Bucket public berarti siapa pun dapat melihat/mengunduh foto. Policy SELECT mengizinkan galeri publik. Policy INSERT hanya mengizinkan email dalam daftar; tidak ada policy UPDATE/DELETE.
4. Kebijakan server adalah pengaman sebenarnya; daftar email di `app.js` hanya mengatur tampilan tombol.

## 4. Deploy publik via Firebase Hosting (tanpa Firebase Storage)
1. Ekstrak ZIP. Buka folder hasil ekstrak di File Explorer, klik address bar, ketik `cmd`, tekan Enter.
2. Jalankan `firebase login` jika belum login.
3. Jalankan `firebase use --add`, pilih project Firebase Hosting kamu (contohnya `our-little-photobooth-6b8c9`), lalu beri alias `default`.
4. Jalankan `firebase deploy --only hosting`.
5. Buka URL yang ditampilkan, biasanya `https://PROJECT_ID.web.app`.
6. Kembali ke Supabase Authentication > URL Configuration: set Site URL dan tambahkan URL publik tersebut pada Redirect URLs.

`firebase.json` hanya untuk Hosting. Jangan gunakan `firebase deploy --only hosting,storage`.

## 5. Tes
- Buka URL website di jendela incognito: galeri harus dapat dibaca tanpa login.
- Login dengan email yang diizinkan: tombol upload aktif; unggah foto uji.
- Login dengan akun lain: tombol upload tidak aktif; aturan Storage tetap menolak upload.
- Cek URL di perangkat lain. Jangan unggah foto orang tanpa izin.

## Pemecahan masalah
- Login gagal: periksa Google provider, callback URI, Site URL dan Redirect URLs.
- Galeri kosong/error: pastikan bucket bernama `memories`, public, dan SQL policy SELECT berhasil.
- Upload ditolak: pastikan email persis sama pada `app.js` dan SQL, dan pengguna sudah login.
