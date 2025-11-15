
<a href="https://github.com/drshahizan/mobile_apps/stargazers"><img src="https://img.shields.io/github/stars/drshahizan/mobile_apps" alt="Stars Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/network/members"><img src="https://img.shields.io/github/forks/drshahizan/mobile_apps" alt="Forks Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/pulls"><img src="https://img.shields.io/github/issues-pr/drshahizan/mobile_apps" alt="Pull Requests Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/issues"><img src="https://img.shields.io/github/issues/drshahizan/mobile_apps" alt="Issues Badge"/></a>
<a href="https://github.com/drshahizan/mobile_apps/graphs/contributors"><img alt="GitHub contributors" src="https://img.shields.io/github/contributors/drshahizan/mobile_apps?color=2b9348"></a>
![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fdrshahizan%2Fmobile_apps&labelColor=%23d9e3f0&countColor=%23697689&style=flat)

## 🧪 Exercise 1: Getting Started with Firebase Console & Firestore

### 🎯 Objektif

Pada akhir latihan ini, anda akan boleh:

1. Sign in ke **Firebase Console**
2. Cipta **Firebase Project**
3. Aktifkan **Cloud Firestore**
4. Cipta **collection** dan **dokumen** pertama


## Langkah 0 – Prasyarat

Sebelum mula, pastikan:

* Anda ada **akaun Google** (contoh: `nama@gmail.com`)
* Ada **internet** dan browser (Chrome / Safari / Firefox)


## Langkah 1 – Sign in ke Firebase Console

1. Buka browser di Mac anda (contoh: **Google Chrome**).
2. Pada address bar, taip:
   `https://console.firebase.google.com`
3. Tekan **Enter**.
4. Jika belum login, anda akan diminta:

   * Masukkan emel **Google/Gmail**
   * Masukkan **password**
5. Jika login berjaya, anda akan nampak:

   * Sama ada **senarai projek** Firebase (jika pernah buat)
   * Atau butang **“Create a project”** / **“Add project”** jika tiada projek lagi.

✅ **Checkpoint 1:**
Anda sekarang berada di halaman utama **Firebase Console** dalam keadaan sudah login.


## Langkah 2 – Membuat Firebase Project Baharu

1. Pada halaman utama Firebase Console, cari butang:

   * **“Add project”** atau **“Create a project”**
2. Klik butang tersebut.
3. Masukkan **Nama Projek**, contoh:
   `NotaFlutterApp`

   > Tip: Nama projek ini untuk Firebase sahaja (bukan nama app di telefon).
4. Klik **Continue**.
5. Biasanya akan keluar pilihan **Google Analytics**:

   * Untuk latihan, anda boleh pilih **Disable Google Analytics**.
6. Klik **Create project**.
7. Tunggu proses siap sehingga keluar mesej seperti:

   * “Your new project is ready”
8. Klik **Continue**.

✅ **Checkpoint 2:**
Anda kini berada dalam **Project Dashboard** untuk projek yang baru dibuat.


## Langkah 3 – Kenal Pasti Project Overview

Dalam project dashboard:

1. Di kiri, anda nampak menu seperti:

   * **Build**
   * **Release & Monitor**
   * **Analytics**
   * dll.
2. Pastikan di bahagian atas kiri tertulis nama projek anda, contoh:
   `NotaFlutterApp`.

💡 Latihan kecil:

* Cuba klik ikon **gear ⚙ (Settings)** → **Project settings** untuk lihat:

  * Project ID
  * Project number
  * dll.


## Langkah 4 – Aktifkan Cloud Firestore

Sekarang kita mahu aktifkan database jenis **Cloud Firestore**.

1. Di panel kiri, di bawah seksyen **Build**, klik:

   * **Firestore Database**
2. Klik **Create database**.
3. Pilih **Start in test mode** (untuk belajar dulu — nanti boleh tighten rules).
4. Pilih **location** (contoh: `asia-southeast1` jika ada; apa-apa pun boleh untuk latihan).
5. Klik **Enable** / **Create**.
6. Tunggu sehingga proses siap dan anda akan dibawa ke halaman Firestore dengan paparan:

   * **Start collection** (jika belum ada apa-apa data).

✅ **Checkpoint 3:**
Cloud Firestore untuk projek anda sudah diaktifkan, sedia untuk simpan data.


## Langkah 5 – Cipta Collection Pertama

Sekarang kita akan cipta collection seperti folder dalam database, contohnya: `notes`.

1. Pada halaman Firestore, klik butang:

   * **Start collection**
2. Dalam **Collection ID**, tulis:
   `notes`
3. Klik **Next**.


## Langkah 6 – Cipta Dokumen Pertama

Selepas tekan Next, kita akan cipta satu dokumen (rekod) di dalam collection `notes`.

1. Pada **Document ID**:

   * Anda boleh biarkan **Auto-ID** (Firebase akan generate sendiri).
2. Di bahagian **Fields**, tambah 2 field:

   * Field 1:

     * **Field name**: `text`
     * **Type**: `string`
     * **Value**: `Ini nota pertama saya`
   * Field 2:

     * **Field name**: `createdAt`
     * **Type**: `timestamp` (atau `string` jika susah cari)
     * **Value**: sekarang / (atau `2025-11-15` sebagai string)
3. Klik **Save**.

Jika berjaya:

* Anda akan nampak collection `notes`.
* Di dalamnya ada 1 dokumen dengan Auto-ID.
* Di dalam dokumen itu ada field `text` dan `createdAt`.

✅ **Checkpoint 4:**
Anda telah berjaya menyimpan satu dokumen ke dalam **Cloud Firestore**.

## Langkah 7 – Semak & Eksplorasi

Latihan penerokaan:

1. Cuba tambah **dokumen kedua** dalam collection `notes`:

   * Klik **Add document**.
   * Biarkan Auto-ID.
   * Tambah field:

     * `text` (string) → `Ini nota kedua`
     * `createdAt` (timestamp/string)

2. Cuba ubah nilai:

   * Klik pada dokumen pertama.
   * Tukar nilai `text` → `Nota pertama (edited)`.
   * Klik **Update** / **Save**.

3. Cuba padam satu dokumen:

   * Pilih dokumen.
   * Klik ikon **trash/bin** → **Delete document**.

## Langkah 8 – Refleksi Latihan

Jawab soalan refleksi kecil (boleh tulis dalam buku nota):

1. Apa beza:

   * **Project**
   * **Collection**
   * **Document**
   * **Field**
2. Untuk aplikasi nota mudah di telefon, berikan contoh:

   * Nama collection
   * 3 field yang sesuai (contoh: `title`, `content`, `createdAt`)

## Bonus: Sambungan ke Flutter (Idea Ringkas)

Selepas latihan ini, secara konsepnya:

* Flutter app akan:

  * **Connect** ke projek Firebase yang sama.
  * Guna koleksi `notes` yang anda cipta.
* Kod Flutter (contoh) akan buat:

  * `FirebaseFirestore.instance.collection('notes').add({...})`
  * `StreamBuilder` untuk baca senarai dokumen dalam `notes`.


## Contribution 🛠️
Please create an [Issue](https://github.com/drshahizan/mobile_apps/issues) for any improvements, suggestions or errors in the content.

You can also contact me using [Linkedin](https://www.linkedin.com/in/drshahizan/) for any other queries or feedback.

[![Visitors](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2Fdrshahizan&labelColor=%23697689&countColor=%23555555&style=plastic)](https://visitorbadge.io/status?path=https%3A%2F%2Fgithub.com%2Fdrshahizan)
![](https://hit.yhype.me/github/profile?user_id=81284918)


