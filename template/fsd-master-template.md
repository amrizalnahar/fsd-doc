---
# ===========================================================================
#  METADATA SAMPUL (.docx). Blok YAML ini WAJIB berada di baris paling atas.
#  - Mengisi HALAMAN SAMPUL saat dokumen dikonversi ke .docx (lihat ../docx-kit/).
#  - Pandoc merender: title, subtitle, author, date pada sampul. Field lain di
#    bawah bersifat informatif (tampil sebagai tabel saat dibaca di GitHub).
#  - Isi placeholder sebelum konversi. Lihat "Cara pakai" poin 10.
# ===========================================================================
title: "Functional Specification Document"
subtitle: "{{Nama Modul}} — {{project.name}}"
author:
  - "Versi {{1.0}}"
  - "Disusun oleh {{project.vendor}} untuk {{project.client}}"
date: "{{DD Bulan YYYY}}"
lang: "{{project.language}}"
status: "Menggambarkan fungsi yang sudah berjalan pada sistem"
confidentiality: "{{project.confidentiality}}"
---

<!--
============================================================================
  TEMPLATE MASTER FSD (Functional Specification Document)
  Satu dokumen = satu MODUL, memuat SEMUA menu modul tersebut.
============================================================================
  Cara pakai:
  1. Salin file ini menjadi  fsd-master-{modul}.md  di folder yang sama.
     Contoh nama:
       - fsd-master-applicant.md
       - fsd-master-admin-panel.md
       - fsd-master-ta.md
     Satu file master hanya untuk SATU modul. Modul lain → file master sendiri.

  2. Struktur dokumen berbentuk BAB (format Indonesia: BAB I, BAB II, ...):
       BAB I               — Informasi Umum Modul → diisi SEKALI, acuan semua bab.
       BAB II, III, IV, ... — Spesifikasi per Menu → SATU BAB per menu.
     Sub-bab mengikuti nomor bab: BAB I → 1.1, 1.2; BAB II → 2.1, 2.2; dst.
     Kerjakan SEKUENSIAL: selesaikan penuh satu bab menu (mis. 2.1 s.d. 2.10)
     sebelum lanjut ke menu berikutnya. Satu bab selesai = satu menu tuntas 100%,
     termasuk lampiran teknis (dev/QA) di ujung bab.

  3. Menambah menu baru:
       - Salin seluruh blok  "=== POLA BAB MENU ==="  (BAB II di bawah).
       - Naikkan nomor bab (III, IV, V, ...) dan sub-babnya (3.x, 4.x, ...).
       - Ganti {{PREFIX}} menu (mis. SV, MA, SJ) dan isi semua {{PLACEHOLDER}}.
       - Tambahkan barisnya pada "Peta Menu" (sub-bab 1.4) sebagai pelacak progres.

  4. Isi setiap {{PLACEHOLDER}} dan hapus baris komentar panduan (baris yang
     diapit tanda komentar HTML) setelah bagian tersebut selesai diisi. Baris
     tabel bertanda "(contoh — ganti)" hanya ilustrasi; ganti dengan data Anda,
     jangan disisakan.

  5. Prinsip FSD ini: jelaskan APA yang dilakukan sistem dan MENGAPA (untuk
     verifikasi fungsional bersama klien/UAT), BUKAN bagaimana sistem dibangun
     secara teknis. Detail teknis hanya di sub-bab Lampiran Teknis tiap bab.

  6. Sub-bab "Lampiran Teknis" pada SETIAP bab menu (mis. 2.10, 3.10, dst.)
     memuat ERD dan kontrak endpoint, dan IKUT diserahkan ke klien — tidak
     dipangkas.

  7. Bahasa dokumen: Bahasa Indonesia. Simpan screenshot di ./images/ (atau
     subfolder per modul/menu, mis. ../images/applicant/search-vacancy/).

  8. Konvensi ID (BER-PREFIX MENU agar tidak bentrok antar-menu):
       - Fungsi        : {{PREFIX}}-01, {{PREFIX}}-02, ...   (mis. SV-01)
       - Aturan bisnis : {{PREFIX}}-BR-01, {{PREFIX}}-BR-02  (mis. SV-BR-01)
     Pilih {{PREFIX}} pendek yang mewakili menu dan pakai konsisten dalam bab.

  9. Diagram (alur proses, interaksi peran↔sistem, ERD):
     - Semua diagram DISIMPAN sebagai GAMBAR PNG di ./images/ — BUKAN HTML/ASCII —
       agar ter-embed rapi saat dokumen dikonversi ke .docx untuk klien.
     - Sumber diagram WAJIB ditulis sebagai kode Mermaid dan DISIMPAN sebagai file
       .mmd (satu .mmd per gambar, nama sama dengan PNG-nya), lalu LANGSUNG
       dirender ke PNG dengan mermaid-cli (mmdc). Jangan paste/export manual ke
       mermaid.live — cukup jalankan mmdc:
           Install sekali :  npm install -g @mermaid-js/mermaid-cli
           Render (baku)  :  mmdc -i ./images/{{prefix}}-{topik}.mmd \
                                  -o ./images/{{prefix}}-{topik}.png -b white -s 3
       Flag baku: -b white (latar putih) + -s 3 (skala 3× agar tajam di .docx).
     - Jenis diagram & sintaks Mermaid yang dipakai (SERAGAM di semua dokumen):
         • Alur proses / interaksi peran↔sistem → flowchart (subgraph per peran)
           atau sequenceDiagram.
         • Struktur tabel & relasi (ERD, sub-bab .10.1) → WAJIB erDiagram
           (BUKAN flowchart / gambar tangan / tabel). Konvensi warna & kerangka
           lengkap ada di sub-bab 2.10.1.
     - Konvensi nama file gambar: {{prefix}}-{topik}.png (+ file .mmd sumbernya)
       (mis. sv-alur-mencari.png, sv-diagram-alur.png, sv-erd.png).

  10. Konversi ke .docx & HALAMAN SAMPUL (untuk klien):
      Tampilan .docx yang rapi/elegan/profesional TIDAK diatur di dalam .md,
      melainkan di lapisan konversi. Kit-nya ikut di paket skill: docx-kit/
        - reference.docx           → template gaya Word ber-brand (warna/font
                                      dari brand.* pada doc-fsd.config.yml):
                                      sampul, heading, tabel, nomor halaman, satu
                                      BAB per halaman, dan perataan baku (paragraf
                                      isi rata kanan-kiri/justify, teks di dalam
                                      sel tabel rata kiri, gambar & blok tabel
                                      rata tengah).
        - build-docx.ps1           → satu perintah konversi (butuh Pandoc).
        - README.md                → panduan lengkap + cara ganti warna/logo.
      Cara termudah: jalankan mode  /doc-fsd build {modul}  (memakai docx-kit
      paket skill + nilai brand dari config). Setara perintah manual:
          docx-kit/build-docx.ps1 {output.documents_dir}/fsd-{modul}.md
      Nama file .docx keluaran berpola FSD-Modul-{Modul}: {Modul} diambil dari
      nama .md setelah membuang awalan "fsd-master-" lalu tiap segmen antar-tanda-
      hubung dikapitalkan (mis. fsd-master-public.md -> FSD-Modul-Public.docx;
      fsd-master-admin-ta.md -> FSD-Modul-Admin-Ta.docx). Pakai -Out untuk
      menimpa dengan nama khusus.
      HALAMAN SAMPUL diambil dari blok metadata YAML di paling atas file ini
      (title, subtitle, author, date) — isi placeholder-nya sebelum konversi.
      Daftar Isi dibuat OTOMATIS oleh Word (opsi --toc); nomor bab tetap dari
      penomoran manual (jangan pakai --number-sections).

      Sebelum mengonversi SALINAN KLIEN, pangkas hal berikut (kerjakan pada
      salinan, biar file master tetap utuh untuk dibaca di GitHub):
        a. Isi metadata YAML sampul (judul, modul, versi, tanggal, dst.).
        b. Hapus blok "Daftar Isi" MANUAL di bawah — Word membuatnya otomatis;
           bila dibiarkan → Daftar Isi ganda. (Blok manual hanya untuk GitHub.)
        c. Hapus baris judul "# Master Functional..." + header bold ganda; sampul
           sudah datang dari metadata.
        d. Pastikan semua diagram sudah berupa PNG (poin 9), bukan .mmd.

  11. Agar render Word tetap rapi (berlaku saat menulis body):
        - Jangan bikin tabel terlalu lebar/kolom terlalu banyak — Word sulit
          membungkusnya. Pecah jadi beberapa tabel bila perlu.
        - Tiap BAB otomatis mulai di halaman baru (diatur reference.docx); tidak
          perlu memaksa page-break manual.
        - Hindari HTML di body (kecuali komentar panduan) dan tabel bersarang.
============================================================================
-->

# Master Functional Specification Document — {{Nama Modul}}

**Aplikasi:** {{project.name}}
**Modul:** {{Nama Modul — dari modules[].title pada doc-fsd.config.yml}}
**Versi dokumen:** {{1.0}}
**Tanggal:** {{DD Bulan YYYY}}
**Status:** Menggambarkan fungsi yang sudah berjalan pada sistem
**Perubahan versi ini:** {{ringkas apa yang berubah dari versi sebelumnya; untuk versi 1.0 tulis "Versi awal."}}

<!-- panduan header:
     - Pilih satu modul dari `modules[]` pada doc-fsd.config.yml. Tiap entri
       modul menetapkan: title (Nama Modul), portal (backend/frontend →
       rujuk codebase.*), guard (mis. auth:...), dan lokasi kredensial.
     - Dokumen ini memuat SELURUH menu modul di atas. Satu bab per menu. -->

Dokumen ini adalah spesifikasi fungsional **seluruh menu** pada {{Nama Modul}} {{project.name}}. Disusun untuk verifikasi fungsional (UAT) bersama klien: menjelaskan **apa** yang dilakukan sistem dan **mengapa**, bukan detail teknis. Detail teknis dikumpulkan pada sub-bab Lampiran Teknis di ujung setiap bab menu.

---

<!-- Daftar Isi manual di bawah HANYA untuk pembacaan di GitHub. Saat konversi
     ke .docx, Word membuat Daftar Isi otomatis (--toc) — HAPUS blok manual ini
     pada salinan yang dikonversi agar tidak ganda. Lihat "Cara pakai" poin 10. -->

## Daftar Isi

**BAB I — Informasi Umum Modul**

- 1.1 [Pendahuluan](#11-pendahuluan)
- 1.2 [Glosarium & Istilah](#12-glosarium--istilah)
- 1.3 [Peran & Hak Akses Umum](#13-peran--hak-akses-umum)
- 1.4 [Peta Menu & Pelacak Progres](#14-peta-menu--pelacak-progres)

**BAB II — Menu: {{Nama Menu Pertama}}**

- 2.1 [Gambaran Umum & Posisi Menu](#21-gambaran-umum--posisi-menu)
- 2.2 [Daftar Fungsi](#22-daftar-fungsi)
- 2.3 [Data & Isian Formulir](#23-data--isian-formulir)
- 2.4 [Aturan Bisnis](#24-aturan-bisnis)
- 2.5 [Hak Akses (Khusus Menu)](#25-hak-akses-khusus-menu)
- 2.6 [Alur Proses](#26-alur-proses)
- 2.7 [Pesan Sistem](#27-pesan-sistem)
- 2.8 [Antarmuka Pengguna](#28-antarmuka-pengguna)
- 2.9 [Keterkaitan dengan Menu Lain](#29-keterkaitan-dengan-menu-lain)
- 2.10 [Lampiran Teknis](#210-lampiran-teknis)

<!-- Tambahkan blok "BAB III — Menu: ...", "BAB IV — Menu: ...", dst. untuk tiap
     menu berikutnya (pola sub-bab sama dengan BAB II). -->

---
---

# BAB I — INFORMASI UMUM PORTAL

<!-- Bab ini diisi SEKALI untuk seluruh modul dan menjadi acuan bersama semua
     bab menu. Jangan mengulang isi bab ini di dalam bab menu. -->

## 1.1 Pendahuluan

### 1.1.1 Tujuan Dokumen

Dokumen ini menjelaskan spesifikasi fungsional seluruh menu pada **{{Nama Modul}}** {{project.name}}: {{satu-dua kalimat merangkum siapa pengguna modul ini dan apa tujuan utama mereka menggunakannya}}.

Dokumen ditulis untuk kebutuhan verifikasi fungsional bersama klien — menjelaskan **apa** yang dilakukan sistem dan **mengapa**, bukan bagaimana sistem dibangun secara teknis.

### 1.1.2 Ruang Lingkup

Termasuk dalam ruang lingkup dokumen ini:

- Seluruh menu {{Nama Modul}} yang tercantum pada **Peta Menu (sub-bab 1.4)**.
- {{tambahkan cakupan lintas-menu tingkat tinggi bila perlu}}

Tidak termasuk dalam ruang lingkup dokumen ini:

- Menu pada modul lain — lihat dokumen master masing-masing (mis. `fsd-master-{{modul-lain}}.md`).
- Spesifikasi teknis (struktur basis data, antarmuka program, arsitektur sistem) selain yang tercantum pada sub-bab Lampiran Teknis tiap bab.
- {{fitur/alur lain yang sengaja dikecualikan — sebut dokumennya}}

### 1.1.3 Pembaca yang Dituju

{{Pemilik proses bisnis, administrator/operator, tim penguji (UAT), pengembang, dan pihak lain yang relevan}}.

### 1.1.4 Cara Membaca Dokumen

- **BAB I** memuat informasi yang berlaku untuk semua menu (istilah, peran, hak akses umum, peta menu).
- **BAB II dan seterusnya** memuat satu bab mandiri per menu. Tiap bab dapat dibaca dan diverifikasi secara berdiri sendiri.
- Konvensi ID: fungsi ber-*prefix* menu (mis. `SV-01`), aturan bisnis ber-*prefix* menu (mis. `SV-BR-01`). Prefix tiap menu didaftarkan pada Peta Menu (sub-bab 1.4).

---

## 1.2 Glosarium & Istilah

<!-- panduan: masukkan istilah yang dipakai LINTAS menu di modul ini. Istilah
     yang khas satu menu saja letakkan di sub-bab "Gambaran Umum" bab menu itu.
     Sertakan padanan bahasa Inggris dalam *italic* bila perlu. -->

| Istilah | Definisi |
|---|---|
| **{{Istilah 1}}** | {{Definisi ringkas dari sudut pandang pengguna}} |
| **{{Istilah 2}}** | {{Definisi}} |
| **{{Istilah 3}}** | {{Definisi}} |

---

## 1.3 Peran & Hak Akses Umum

<!-- panduan: jelaskan model hak akses proyek (mis. RBAC/capability kustom,
     peran, atau grup) SATU KALI untuk seluruh modul; tiap bab menu cukup
     merujuk ke bagian ini dan hanya menyebut capability KHUSUS menunya. -->

### 1.3.1 Sesi & Guard Modul

{{Jelaskan cara pengguna masuk ke modul ini: guard/otentikasi, syarat status akun (mis. verified/aktif), dan batasan akses tingkat modul. Contoh: "Modul diakses dengan sesi <peran> (guard `<guard>`); pengguna harus terverifikasi dan berstatus aktif."}}

### 1.3.2 Model Hak Akses

{{Jelaskan bagaimana hak akses diberikan pada modul ini — mis. per-menu capability, peran, atau grup. Jelaskan pola umum "Lihat / Tambah / Ubah / Hapus" bila berlaku, dan bagaimana ketiadaan hak memengaruhi tampilan (menu tidak muncul, tombol tersembunyi, halaman 403).}}

| Hak Akses (umum) | Kemampuan yang Diberikan |
|---|---|
| **Lihat** | {{Melihat menu, membuka daftar, mencari, menyaring, membuka detail}} |
| **Tambah** | {{Menampilkan tombol tambah dan menyimpan data baru}} |
| **Ubah** | {{Menampilkan menu Edit dan menyimpan perubahan}} |
| **Hapus** | {{Menampilkan tombol Hapus dan menghapus/mengarsipkan data}} |

<!-- panduan: bila modul ini tidak memakai pola Lihat/Tambah/Ubah/Hapus
     (mis. Applicant Portal yang berbasis peran applicant), ganti tabel di atas
     dengan model yang sesuai. -->

### 1.3.3 Audit Log (berlaku umum)

{{Bila seluruh perubahan tercatat pada Audit Log, nyatakan sekali di sini: pendaftaran, perubahan, dan penghapusan tercatat beserta identitas pelaku dan waktu kejadian. Tiap bab menu cukup merujuk ke sub-bab ini. Hapus bila tidak relevan untuk modul ini.}}

---

## 1.4 Peta Menu & Pelacak Progres

<!-- panduan: daftar SELURUH menu modul beserta prefix ID dan status
     dokumentasinya. Berfungsi sebagai daftar-isi hidup + pelacak kerja
     sekuensial: menu mana yang sudah/belum didokumentasikan. Perbarui kolom
     Status setiap kali sebuah bab selesai. -->

| Bab | Menu | Prefix ID | Rute / Lokasi | Status Dokumentasi |
|---|---|---|---|---|
| II | {{Search Vacancy}} (contoh — ganti) | {{SV}} | {{/pekerjaan}} | {{Belum / Draf / Selesai}} |
| III | {{My Application}} (contoh — ganti) | {{MA}} | {{/lamaran}} | {{Belum}} |
| IV | {{Saved Job}} (contoh — ganti) | {{SJ}} | {{/tersimpan}} | {{Belum}} |
| … | {{…}} | {{…}} | {{…}} | {{…}} |

**Keterangan status:** *Belum* = belum digarap · *Draf* = sedang diisi · *Selesai* = lengkap & terverifikasi.

---
---

<!--
============================================================================
  === POLA BAB MENU (SALIN BLOK INI UNTUK TIAP MENU BARU) ===
  - Untuk menu berikutnya, salin seluruh BAB II di bawah, lalu:
      • Naikkan nomor bab (BAB III, BAB IV, ...) dan sub-babnya (3.x, 4.x, ...).
      • Ganti {{Nama Menu}} dan {{PREFIX}} (mis. MA).
      • Isi semua {{PLACEHOLDER}}, hapus baris "(contoh — ganti)".
  - Tiap bab bersifat MANDIRI: bisa dibaca & diverifikasi berdiri sendiri.
  - Sub-bab .10 (Lampiran, Internal) DIPANGKAS pada salinan untuk klien.
============================================================================
-->

# BAB II — MENU: {{Nama Menu Pertama}}

**Prefix ID menu:** `{{PREFIX}}` — **Rute:** {{/rute-menu}}
**Perubahan versi ini:** {{ringkas; untuk versi awal tulis "Versi awal."}}

---

## 2.1 Gambaran Umum & Posisi Menu

**Posisi dalam aplikasi.** Menu ini berada pada {{lokasi menu — mis. "menu utama X di sidebar" / "submenu Y di bawah Z"}} pada {{Nama Modul}}, dengan rute `{{/rute}}`. {{Kondisi kemunculan menu, mis. "Menu hanya muncul bagi pengguna yang memiliki hak akses menu ini."}}

**Konsep dasar.** {{Jelaskan model mental inti menu dalam 1–3 paragraf: entitas utama, apa yang disimpan/diatur sistem, dan prinsip pentingnya. Fokus pada makna bisnis, bukan teknis.}}

<!-- panduan (opsional): bila alur peran↔sistem memperjelas konsep, sisipkan
     diagram sebagai GAMBAR PNG, BUKAN ASCII — agar rapi saat dokumen dikonversi
     ke .docx. Tulis kode Mermaid lalu render dengan mmdc (lihat poin 9 pada
     "Cara pakai" di atas). Hapus bila tidak perlu. -->

![{{Diagram interaksi peran & sistem}}](<./images/{{prefix}}-diagram-alur.png>)

*Gambar {{2.x}} — {{ringkas interaksi antar-peran/sistem pada menu ini}}.*

**Siklus hidup & status {{Entitas}} (opsional).** {{Gunakan bila entitas menu punya status/tahapan; hapus seluruh blok ini bila entitas tidak berstatus.}}

<!-- panduan: daftar transisi status yang DIIZINKAN — satu baris per transisi.
     "Dari" kosong = status awal saat entitas dibuat. Sebutkan pemicu (aksi/
     kejadian), syarat/aturan yang berlaku, dan peran yang boleh melakukannya.
     Prinsip penting tulis sebagai kalimat di bawah tabel. -->

| Dari Status | Pemicu | Ke Status | Syarat / Aturan | Pelaku |
|---|---|---|---|---|
| _(baru dibuat)_ | {{aksi membuat}} | {{Draft}} | {{—}} | {{peran}} |
| {{Draft}} | {{aksi mengaktifkan}} | {{Aktif}} | {{syarat}} | {{peran}} |
| {{Aktif}} | {{aksi menonaktifkan}} | {{Nonaktif}} | {{syarat}} | {{peran}} |
| {{Nonaktif}} | {{aksi mengarsipkan}} | {{Diarsipkan}} | {{syarat}} | {{peran}} |

{{Prinsip penting, mis. "Entitas yang sudah dipakai pada transaksi lain tidak dapat dihapus — hanya dinonaktifkan."}}

---

## 2.2 Daftar Fungsi

<!-- panduan: satu baris per fungsi yang benar-benar ada. Urutkan mengikuti alur
     pemakaian (lihat → cari → saring → tambah → ubah → hapus → proses lanjutan →
     notifikasi/audit). Selaraskan ID dengan sub-bab 2.4, 2.6, 2.7. -->

| ID | Nama Fungsi | Keterangan |
|---|---|---|
| {{PREFIX}}-01 | {{Melihat daftar ...}} | {{Keterangan singkat}} |
| {{PREFIX}}-02 | {{Mencari ...}} | {{Keterangan}} |
| {{PREFIX}}-03 | {{Menyaring berdasarkan ...}} | {{Keterangan}} |
| {{PREFIX}}-04 | {{Mendaftarkan / menambah ...}} | {{Keterangan}} |
| {{PREFIX}}-05 | {{Mengubah ...}} | {{Keterangan}} |
| {{PREFIX}}-06 | {{Menghapus / menonaktifkan ...}} | {{Keterangan}} |
| {{PREFIX}}-07 | {{Proses lanjutan ...}} | {{Keterangan}} |

---

## 2.3 Data & Isian Formulir

Notasi: **W** = wajib diisi, **O** = opsional.

### 2.3.1 Isian {{Nama Entitas}}

| Field | W/O | Ketentuan Pengisian |
|---|---|---|
| **{{Nama Field}}** | W | {{Batas panjang, keunikan, format, dsb. dalam bahasa pengguna}} |
| **{{Nama Field}}** | O | {{Ketentuan}} |
| **Status** | W | {{Nilai yang mungkin + nilai bawaan + kapan bisa diubah}} |
<!-- panduan: tuliskan aturan sebagaimana dirasakan pengguna (mis. "Maksimal 200
     karakter", "Harus alamat email valid"), bukan tipe kolom database. Detail
     kolom database ada di Lampiran (2.10). -->

### 2.3.2 {{Pilihan / Opsi Khusus}} (opsional)

<!-- panduan: gunakan untuk pilihan bercabang yang mengubah perilaku form
     (mis. radio/kartu yang menampilkan/menyembunyikan field lain). Atau untuk
     mendaftarkan nilai enum + labelnya di layar. Hapus bila tidak ada. -->

| Pilihan / Nilai | Label pada Layar | Perilaku |
|---|---|---|
| {{opsi A}} | "{{label persis di layar}}" | {{apa yang terjadi bila dipilih}} |
| {{opsi B}} | "{{label}}" | {{perilaku}} |

### 2.3.3 Data yang Dihasilkan Sistem (opsional)

<!-- panduan: data yang dibuat/dihitung otomatis oleh sistem, bukan diisi
     pengguna (mis. token, kode unik, waktu server, jumlah relasi). Hapus bila
     tidak ada. -->

| Data | Keterangan |
|---|---|
| **{{Data 1}}** | {{Bagaimana dan kapan dibentuk, untuk apa dipakai}} |

---

## 2.4 Aturan Bisnis

<!-- panduan: satu baris per aturan yang dapat diverifikasi saat UAT. Bunyikan
     sebagai pernyataan tegas (bold) + penjelasan. ID ber-prefix menu agar tidak
     bentrok dengan bab lain. -->

| ID | Aturan | Penjelasan |
|---|---|---|
| {{PREFIX}}-BR-01 | **{{Aturan singkat, mis. Nama tidak boleh ganda}}** | {{Penjelasan + kondisi berlakunya}} |
| {{PREFIX}}-BR-02 | **{{Aturan validasi}}** | {{Penjelasan}} |
| {{PREFIX}}-BR-03 | **{{Aturan hak akses / visibilitas}}** | {{Penjelasan}} |
| {{PREFIX}}-BR-04 | **{{Aturan penghapusan / arsip}}** | {{Penjelasan}} |
| {{PREFIX}}-BR-05 | **{{Aturan notifikasi}}** | {{Penjelasan}} |

---

## 2.5 Hak Akses (Khusus Menu)

<!-- panduan: JANGAN mengulang model hak akses umum (sudah di sub-bab 1.3). Di
     sini hanya sebut capability/hak yang KHUSUS menu ini dan perilaku antarmuka
     yang spesifik. Bila menu ini persis mengikuti pola umum, cukup rujuk 1.3. -->

Mengacu pada model hak akses modul (sub-bab 1.3). Khusus menu ini:

| Hak Akses | Kemampuan yang Diberikan |
|---|---|
| **{{Hak / capability menu, mis. `saved-job`}}** | {{Kemampuan yang diberikan pada menu ini}} |

**Perilaku antarmuka berdasarkan hak akses:**

| Kondisi Pengguna | Yang Terjadi di Layar |
|---|---|
| {{Tidak punya hak "Lihat"}} | {{Menu tidak muncul; halaman tidak dapat diakses (mis. 403)}} |
| {{Punya "Lihat" saja}} | {{Daftar tampil; tombol/menu tertentu tidak ada}} |
| {{Punya hak khusus menu}} | {{Elemen tambahan muncul}} |

<!-- panduan gambar bukti (opsional, disarankan untuk UAT): screenshot pengguna
     tanpa hak akses & halaman penolakan. Hapus bila tidak dipakai. -->

![{{Bukti hak akses}}](<./images/{{prefix}}-hak-akses.png>)

*Gambar {{2.x}} — {{Keterangan bukti hak akses}}.*

---

## 2.6 Alur Proses

<!-- panduan: satu sub-bab per alur utama. Langkah bernomor adalah SUMBER
     KEBENARAN yang diverifikasi saat UAT; diagram alur (bila ada) hanya
     PELENGKAP visual. Cantumkan titik validasi dan pesan yang muncul; selaraskan
     dengan 2.7 Pesan Sistem. Tambah/kurangi alur sesuai kebutuhan menu. -->

### 2.6.1 {{Alur utama, mis. Mencari & Menyaring / Menambah Data}}

<!-- panduan DIAGRAM (opsional, disarankan untuk alur bercabang): sisipkan
     flowchart/swimlane sebagai GAMBAR PNG hasil render Mermaid — BUKAN HTML/ASCII.
     Alur kerja tanpa paste/export manual:
       1) Tulis kode Mermaid ke  ./images/{{prefix}}-alur-{topik}.mmd
       2) Render :  mmdc -i ./images/{{prefix}}-alur-{topik}.mmd \
                         -o ./images/{{prefix}}-alur-{topik}.png
     (mmdc = mermaid-cli; lihat poin 9 pada "Cara pakai" untuk install sekali.)
     Untuk "swimlane" peran↔sistem, pakai flowchart + subgraph per peran, atau
     sequenceDiagram. Hapus blok gambar ini bila alur cukup dengan teks. -->

![{{Diagram alur ...}}](<./images/{{prefix}}-alur-{topik}.png>)

*Gambar {{2.x}} — Diagram alur {{ringkas alur yang digambarkan}}.*

<!-- Contoh kode Mermaid (swimlane peran↔sistem via subgraph). Simpan ke file
     .mmd lalu render dengan mmdc; hapus contoh ini setelah dipakai:
flowchart TD
  subgraph Pengguna
    A([Buka menu]) --> B[Isi/pilih data]
  end
  subgraph Sistem
    B --> C{Valid?}
    C -- Tidak --> D[Tampilkan pesan kesalahan]
    C -- Ya --> E[Simpan / proses]
    E --> F[Tampilkan notifikasi]
  end
  D --> B
-->

<!-- panduan LANGKAH: tulis sebagai daftar bernomor. Untuk percabangan, pakai
     sub-butir (indentasi) — BUKAN ASCII — agar terkonversi jadi daftar Word yang
     rapi. Cantumkan titik validasi & pesan; selaraskan dengan 2.7 Pesan Sistem. -->

1. Pengguna membuka menu {{Nama Menu}} (`{{/rute}}`).
2. {{langkah}}.
3. Pengguna dapat:
   - {{cabang aksi A}} → {{hasil}}
   - {{cabang aksi B}} → {{hasil}}
4. Sistem memvalidasi:
   - {{kondisi gagal}} → {{pesan kesalahan}}
   - Bila valid → lanjut ke langkah berikutnya.
5. Sistem {{menyimpan/menampilkan hasil}} + {{efek samping otomatis bila ada}}.
6. Sistem menampilkan notifikasi {{...}}.

### 2.6.2 {{Alur berikutnya, mis. Mengubah / Menghapus}}

1. {{langkah}}.
2. {{konfirmasi bila ada — kutip teks persis}}.
3. {{hasil}}.

---

## 2.7 Pesan Sistem

<!-- panduan: kutip pesan PERSIS seperti tampil di aplikasi (Bahasa Indonesia).
     Bila ada pesan yang masih berbahasa Inggris atau belum konsisten, catat apa
     adanya — berguna sebagai temuan UAT. -->

| Kejadian | Pesan yang Ditampilkan | Bentuk |
|---|---|---|
| {{Data berhasil dibuat}} | "{{pesan}}" | Notifikasi hijau |
| {{Data berhasil diubah}} | "{{pesan}}" | Notifikasi hijau |
| {{Data berhasil dihapus}} | "{{pesan}}" | Notifikasi hijau |
| {{Validasi field X gagal}} | "{{pesan}}" | Teks di bawah field |
| {{Konfirmasi hapus}} | "{{pesan}}" | Dialog konfirmasi |
| {{Sedang memuat}} | "Memuat..." | Teks di area tabel/formulir |
| {{Hasil pencarian kosong}} | "{{pesan}}" | Teks di area tabel |

---

## 2.8 Antarmuka Pengguna

Seluruh tangkapan layar diambil langsung dari {{runtime.target_url — dari doc-fsd.config.yml}} pada {{DD Bulan YYYY}} dengan bahasa antarmuka **{{project.language}}** dan akun {{peran/hak yang dipakai}}. Isi datanya adalah data lingkungan uji.

<!-- panduan: gunakan agent-browser untuk mengambil screenshot langsung dari
     aplikasi live. Simpan gambar di ./images/ (boleh subfolder per menu) dan
     beri nama berpola {{prefix}}-{topik}.png. -->

### 2.8.1 Halaman Daftar / Utama

![{{Halaman utama menu}}](<./images/{{prefix}}-daftar.png>)

*Gambar {{2.x}} — {{Keterangan halaman + hal yang perlu diperhatikan}}.*

| Elemen | Perilaku |
|---|---|
| {{Kolom/komponen}} | {{Perilaku}} |
| Penyaring | {{Field penyaring + apakah langsung berlaku / ada tombol Terapkan}} |
| Menu aksi | {{Berisi Edit/Hapus sesuai hak akses}} |
| Kondisi tampilan | {{Apakah pencarian/penyaringan/urutan/halaman tersimpan di URL}} |

### 2.8.2 Halaman Tambah / Ubah / Detail

![{{Halaman tambah/ubah/detail}}](<./images/{{prefix}}-detail.png>)

*Gambar {{2.x}} — {{Keterangan tata letak}}.*

| Elemen | Perilaku |
|---|---|
| Field bertanda **\*** | Wajib diisi |
| {{Komponen khusus}} | {{Perilaku}} |
| **Batal** | {{Perilaku kembali}} |

---

## 2.9 Keterkaitan dengan Menu Lain

<!-- panduan: satu baris/sub-poin per menu atau modul yang berhubungan. Jelaskan
     arah dan sifat keterkaitan dari sudut pandang bisnis. Rujuk bab menu terkait
     di dokumen ini (mis. "lihat BAB III") atau dokumen master modul lain. -->

| Menu / Modul Terkait | Sifat Keterkaitan |
|---|---|
| {{Master Data / Referensi}} | {{Data referensi apa yang dipakai menu ini}} |
| {{Menu lain di modul ini (BAB ...)}} | {{Apa yang dibagikan / dipicu}} |
| Notifikasi | {{Kejadian yang memicu notifikasi, ke siapa}} |
| Audit Log | {{Lihat sub-bab 1.3.3 — perubahan pada menu ini tercatat}} |

---

<!-- ============================================================================
     MULAI DARI SINI: LAMPIRAN TEKNIS BAB INI (2.10)
     Ditujukan bagi tim pengembang & penguji. Memuat ERD dan kontrak endpoint
     yang juga diserahkan ke klien.
     ============================================================================ -->

## 2.10 Lampiran Teknis

Sub-bab ini ditujukan bagi tim pengembang & penguji. Memuat struktur data (ERD) dan kontrak endpoint yang menopang menu ini.

### 2.10.1 Struktur Tabel & Relasi (ERD)

Memperlihatkan tabel basis data ({{codebase.backend.db}}) yang dipakai menu ini beserta relasinya. Sumber kebenaran adalah migrasi & model backend (lihat `codebase.backend.migrations` dan `codebase.backend.models` pada doc-fsd.config.yml).

<!-- panduan ERD (WAJIB SERAGAM — ikuti persis agar semua dokumen konsisten):
     1) ERD DITULIS sebagai Mermaid `erDiagram` (BUKAN flowchart, BUKAN gambar
        tangan, BUKAN tabel). Simpan sumbernya ke:
            ./images/{{prefix}}-erd.mmd
     2) LANGSUNG render ke PNG (flag baku -b white -s 3, lihat "Cara pakai" poin 9):
            mmdc -i ./images/{{prefix}}-erd.mmd \
                 -o ./images/{{prefix}}-erd.png -b white -s 3
     3) Isi entitas dengan KOLOM KUNCI saja (PK/FK + kolom yang benar-benar dipakai
        menu ini), bukan seluruh kolom. Tandai `PK`/`FK` dan beri komentar singkat
        (dalam tanda kutip) pada kolom penting (mis. status yang harus bernilai
        tertentu).
     4) Relasi memakai notasi crow's foot mermaid (`||--o{` = satu-ke-banyak) dan
        DIBERI LABEL nama foreign key (mis. : "job_order_id"). Boleh ada beberapa
        relasi antar tabel yang sama bila FK-nya berbeda.
     5) WARNA untuk membedakan tabel — pakai `style` (ganti hex dengan
        brand.color_primary / brand.color_primary_dark dari doc-fsd.config.yml):
          - Tabel INTI menu ini   → primer: fill:{{brand.color_primary}},stroke:{{brand.color_primary_dark}},stroke-width:2px,color:#ffffff
          - Tabel modul/menu lain → abu   : fill:#EEF2F6,stroke:#9AA7B4,color:#1f2933
     Kerangka .mmd (ganti nama tabel/kolom sesuai menu, lalu render). Hapus blok
     contoh ini setelah .mmd sungguhan dibuat & dirender:

erDiagram
    %% Kotak biru = tabel inti menu ini; kotak abu = tabel terkait
    {{tabel_inti}} {
        bigint id PK
        bigint {{relasi}}_id FK "keterangan"
        string {{kolom_kunci}} "keterangan (mis. harus 'diposting')"
    }
    {{tabel_terkait}} {
        bigint id PK
        string name
    }
    {{tabel_terkait}} ||--o{ {{tabel_inti}} : "{{foreign_key}}"

    style {{tabel_inti}} fill:{{brand.color_primary}},stroke:{{brand.color_primary_dark}},stroke-width:2px,color:#ffffff
    style {{tabel_terkait}} fill:#EEF2F6,stroke:#9AA7B4,color:#1f2933
-->

![{{ERD menu}}](<./images/{{prefix}}-erd.png>)

*Gambar {{2.x}} — ERD menu {{Nama Menu}} (mermaid `erDiagram`). Kotak biru = tabel inti fitur ini; kotak abu = tabel terkait. Notasi crow's foot (`||--o{`) menandai relasi satu-ke-banyak.*

### 2.10.2 Referensi API/Endpoint

Kontrak endpoint yang menopang menu ini — acuan bagi developer & QA. Untuk Admin Panel (Inertia) umumnya berupa rute web yang mengembalikan halaman/aksi; untuk Applicant/TA Portal (Next.js) umumnya berupa endpoint API yang dikonsumsi frontend.

<!-- panduan: satu baris per endpoint yang benar-benar dipakai menu ini. Sebut
     guard & capability yang menjaganya (rujuk 1.3 & 2.5). Cukup parameter/field
     KUNCI, bukan seluruh payload. Selaraskan kolom "Terkait Fungsi" dengan ID
     pada 2.2 Daftar Fungsi. -->

| Method | Path / Rute | Guard · Capability | Tujuan | Parameter / Field Kunci | Terkait Fungsi |
|---|---|---|---|---|---|
| {{GET}} | {{/rute}} | {{auth:... · capability}} | {{Menampilkan daftar}} | {{page, q, filter[...]}} | {{PREFIX-01}} |
| {{POST}} | {{/rute}} | {{auth:... · capability}} | {{Menyimpan data baru}} | {{field wajib}} | {{PREFIX-04}} |
| {{PUT/PATCH}} | {{/rute/{id}}} | {{auth:... · capability}} | {{Mengubah data}} | {{field yang diubah}} | {{PREFIX-05}} |
| {{DELETE}} | {{/rute/{id}}} | {{auth:... · capability}} | {{Menghapus / menonaktifkan}} | {{id}} | {{PREFIX-06}} |

---
---

<!-- ============================================================================
     === AKHIR POLA BAB MENU ===
     Salin blok BAB II di atas untuk membuat BAB III, IV, V, ... (satu per menu).
     Perbarui juga Daftar Isi dan Peta Menu (sub-bab 1.4).
     ============================================================================ -->
