---
# METADATA SAMPUL (.docx) — WAJIB di baris paling atas. Pandoc merender
# title/subtitle/author/date pada halaman sampul; field lain informatif.
# Isi placeholder sebelum konversi. Aturan pemakaian lengkap: lihat SKILL.md.
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

<!-- TEMPLATE MASTER FSD — satu dokumen = satu MODUL (semua menunya).
     Ini KERANGKA saja. Aturan pemakaian (prinsip FSD, Aturan #1/sumber,
     konvensi ID, render Mermaid, konversi .docx, standar ERD) ada di SKILL.md
     dan TIDAK diulang di sini. Isi tiap {{PLACEHOLDER}}, hapus baris
     "(contoh — ganti)", dan hapus komentar panduan setelah bagian terisi.
     Menu baru = salin blok BAB II, naikkan nomor bab/sub-bab, ganti {{PREFIX}}. -->

# Master Functional Specification Document — {{Nama Modul}}

**Aplikasi:** {{project.name}}
**Modul:** {{Nama Modul — dari modules[].title pada doc-fsd.config.yml}}
**Versi dokumen:** {{1.0}}
**Tanggal:** {{DD Bulan YYYY}}
**Status:** Menggambarkan fungsi yang sudah berjalan pada sistem
**Perubahan versi ini:** {{ringkas perubahan dari versi sebelumnya; versi 1.0 → "Versi awal."}}

Dokumen ini adalah spesifikasi fungsional **seluruh menu** pada {{Nama Modul}} {{project.name}}. Disusun untuk verifikasi fungsional (UAT) bersama klien: menjelaskan **apa** yang dilakukan sistem dan **mengapa**, bukan detail teknis. Detail teknis dikumpulkan pada sub-bab Lampiran Teknis di ujung setiap bab menu.

---

<!-- Daftar Isi manual ini HANYA untuk pembacaan di GitHub. Saat /fsd-convert,
     Word membuat Daftar Isi otomatis — HAPUS blok manual ini pada salinan .docx. -->

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

<!-- Tambah blok "BAB III — Menu: ...", "BAB IV — ...", dst. per menu berikutnya. -->

---
---

# BAB I — INFORMASI UMUM PORTAL

<!-- Diisi SEKALI untuk seluruh modul; jadi acuan semua bab menu. Jangan diulang. -->

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

<!-- Istilah yang dipakai LINTAS menu di modul ini. Istilah khas satu menu →
     letakkan di "Gambaran Umum" bab menu itu. -->

| Istilah | Definisi |
|---|---|
| **{{Istilah 1}}** | {{Definisi ringkas dari sudut pandang pengguna}} |
| **{{Istilah 2}}** | {{Definisi}} |
| **{{Istilah 3}}** | {{Definisi}} |

---

## 1.3 Peran & Hak Akses Umum

<!-- Jelaskan model hak akses (RBAC/capability/peran/grup) SATU KALI untuk
     seluruh modul; bab menu cukup merujuk ke sini + capability khusus menunya. -->

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

<!-- Bila modul tidak memakai pola Lihat/Tambah/Ubah/Hapus, ganti tabel ini
     dengan model yang sesuai. -->

### 1.3.3 Audit Log (berlaku umum)

{{Bila seluruh perubahan tercatat pada Audit Log, nyatakan sekali di sini: pendaftaran, perubahan, dan penghapusan tercatat beserta identitas pelaku dan waktu kejadian. Tiap bab menu cukup merujuk ke sub-bab ini. Hapus bila tidak relevan untuk modul ini.}}

---

## 1.4 Peta Menu & Pelacak Progres

<!-- Daftar SELURUH menu modul + prefix ID + status dokumentasi. Berfungsi
     sebagai daftar-isi hidup + pelacak sekuensial. Perbarui kolom Status tiap
     bab selesai. Status: Belum / Draf / Selesai (lihat keterangan di bawah). -->

| Bab | Menu | Prefix ID | Rute / Lokasi | Status Dokumentasi |
|---|---|---|---|---|
| II | {{Search Vacancy}} (contoh — ganti) | {{SV}} | {{/pekerjaan}} | {{Belum / Draf / Selesai}} |
| III | {{My Application}} (contoh — ganti) | {{MA}} | {{/lamaran}} | {{Belum}} |
| IV | {{Saved Job}} (contoh — ganti) | {{SJ}} | {{/tersimpan}} | {{Belum}} |
| … | {{…}} | {{…}} | {{…}} | {{…}} |

**Keterangan status:** *Belum* = belum digarap · *Draf* = sedang diisi / masih ada klaim tanpa sumber · *Selesai* = lengkap & SETIAP klaim tertaut sumber (lihat Matriks Keterlacakan .10.3) atau ditandai *TIDAK TERVERIFIKASI*.

---
---

<!-- === POLA BAB MENU (SALIN BLOK INI UNTUK TIAP MENU BARU) ===
     Salin seluruh BAB II di bawah → naikkan nomor bab (III, IV, ...) & sub-bab
     (3.x, 4.x, ...), ganti {{Nama Menu}} & {{PREFIX}}, isi placeholder. Tiap bab
     MANDIRI. Sub-bab .10.1 (ERD) & .10.2 (Endpoint) ikut ke klien; hanya .10.3
     (Matriks Keterlacakan, INTERNAL:START/END) dipangkas pada .docx klien. -->

# BAB II — MENU: {{Nama Menu Pertama}}

**Prefix ID menu:** `{{PREFIX}}` — **Rute:** {{/rute-menu}}
**Perubahan versi ini:** {{ringkas; untuk versi awal tulis "Versi awal."}}

---

## 2.1 Gambaran Umum & Posisi Menu

**Posisi dalam aplikasi.** Menu ini berada pada {{lokasi menu — mis. "menu utama X di sidebar" / "submenu Y di bawah Z"}} pada {{Nama Modul}}, dengan rute `{{/rute}}`. {{Kondisi kemunculan menu, mis. "Menu hanya muncul bagi pengguna yang memiliki hak akses menu ini."}}

**Konsep dasar.** {{Jelaskan model mental inti menu dalam 1–3 paragraf: entitas utama, apa yang disimpan/diatur sistem, dan prinsip pentingnya. Fokus pada makna bisnis, bukan teknis.}}

<!-- Opsional: bila alur peran↔sistem memperjelas konsep, sisipkan diagram PNG
     hasil render Mermaid (cara render → SKILL.md). Hapus bila tidak perlu. -->

![{{Diagram interaksi peran & sistem}}](<./images/{{prefix}}-diagram-alur.png>)

*Gambar {{2.x}} — {{ringkas interaksi antar-peran/sistem pada menu ini}}.*

**Siklus hidup & status {{Entitas}} (opsional).** {{Gunakan bila entitas menu punya status/tahapan; hapus seluruh blok ini bila entitas tidak berstatus.}}

<!-- Daftar transisi status yang DIIZINKAN — satu baris per transisi. "Dari"
     kosong = status awal. Sebut pemicu, syarat, dan peran pelaku. Prinsip
     penting tulis sebagai kalimat di bawah tabel. -->

| Dari Status | Pemicu | Ke Status | Syarat / Aturan | Pelaku |
|---|---|---|---|---|
| _(baru dibuat)_ | {{aksi membuat}} | {{Draft}} | {{—}} | {{peran}} |
| {{Draft}} | {{aksi mengaktifkan}} | {{Aktif}} | {{syarat}} | {{peran}} |
| {{Aktif}} | {{aksi menonaktifkan}} | {{Nonaktif}} | {{syarat}} | {{peran}} |
| {{Nonaktif}} | {{aksi mengarsipkan}} | {{Diarsipkan}} | {{syarat}} | {{peran}} |

{{Prinsip penting, mis. "Entitas yang sudah dipakai pada transaksi lain tidak dapat dihapus — hanya dinonaktifkan."}}

---

## 2.2 Daftar Fungsi

<!-- Satu baris per fungsi yang BENAR-BENAR ADA (terbukti di kode). Urutkan
     mengikuti alur pemakaian. Selaraskan ID dengan 2.4, 2.6, 2.7. Beri komentar
     sumber (<!-- Source: file.ext:baris -->) di dekat tiap baris. Tanpa sumber →
     tandai "TIDAK TERVERIFIKASI", jangan dicantumkan. Detail aturan → SKILL.md. -->

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

<!-- Tulis aturan sebagaimana dirasakan pengguna ("Maksimal 200 karakter", "Harus
     email valid"), bukan tipe kolom database (itu ada di 2.10). -->

| Field | W/O | Ketentuan Pengisian |
|---|---|---|
| **{{Nama Field}}** | W | {{Batas panjang, keunikan, format, dsb. dalam bahasa pengguna}} |
| **{{Nama Field}}** | O | {{Ketentuan}} |
| **Status** | W | {{Nilai yang mungkin + nilai bawaan + kapan bisa diubah}} |

### 2.3.2 {{Pilihan / Opsi Khusus}} (opsional)

<!-- Untuk pilihan bercabang yang mengubah perilaku form, atau mendaftarkan enum
     + labelnya di layar. Hapus bila tidak ada. -->

| Pilihan / Nilai | Label pada Layar | Perilaku |
|---|---|---|
| {{opsi A}} | "{{label persis di layar}}" | {{apa yang terjadi bila dipilih}} |
| {{opsi B}} | "{{label}}" | {{perilaku}} |

### 2.3.3 Data yang Dihasilkan Sistem (opsional)

<!-- Data yang dibuat/dihitung otomatis (token, kode unik, waktu server, jumlah
     relasi), bukan diisi pengguna. Hapus bila tidak ada. -->

| Data | Keterangan |
|---|---|
| **{{Data 1}}** | {{Bagaimana dan kapan dibentuk, untuk apa dipakai}} |

---

## 2.4 Aturan Bisnis

<!-- Satu baris per aturan yang bisa diverifikasi saat UAT DAN terbukti di kode
     (validasi/constraint/guard/migrasi). Pernyataan tegas (bold) + penjelasan.
     ID ber-prefix menu. Beri komentar sumber di dekat tiap baris; tanpa sumber →
     "TIDAK TERVERIFIKASI". -->

| ID | Aturan | Penjelasan |
|---|---|---|
| {{PREFIX}}-BR-01 | **{{Aturan singkat, mis. Nama tidak boleh ganda}}** | {{Penjelasan + kondisi berlakunya}} |
| {{PREFIX}}-BR-02 | **{{Aturan validasi}}** | {{Penjelasan}} |
| {{PREFIX}}-BR-03 | **{{Aturan hak akses / visibilitas}}** | {{Penjelasan}} |
| {{PREFIX}}-BR-04 | **{{Aturan penghapusan / arsip}}** | {{Penjelasan}} |
| {{PREFIX}}-BR-05 | **{{Aturan notifikasi}}** | {{Penjelasan}} |

---

## 2.5 Hak Akses (Khusus Menu)

<!-- JANGAN ulang model hak akses umum (sub-bab 1.3). Di sini hanya capability
     KHUSUS menu ini + perilaku antarmuka spesifik. Ikut pola umum → cukup rujuk 1.3. -->

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

<!-- Bukti hak akses (opsional, disarankan untuk UAT): screenshot tanpa hak &
     halaman penolakan. Hapus bila tidak dipakai. -->

![{{Bukti hak akses}}](<./images/{{prefix}}-hak-akses.png>)

*Gambar {{2.x}} — {{Keterangan bukti hak akses}}.*

---

## 2.6 Alur Proses

<!-- Satu sub-bab per alur utama. Langkah bernomor = SUMBER KEBENARAN untuk UAT;
     diagram alur hanya pelengkap. Cantumkan titik validasi + pesan; selaraskan
     dengan 2.7. -->

### 2.6.1 {{Alur utama, mis. Mencari & Menyaring / Menambah Data}}

<!-- Diagram alur (opsional, disarankan untuk alur bercabang): sisipkan PNG hasil
     render Mermaid (flowchart + subgraph per peran, atau sequenceDiagram). Cara
     render + contoh kode → SKILL.md. Hapus blok gambar bila alur cukup teks. -->

![{{Diagram alur ...}}](<./images/{{prefix}}-alur-{topik}.png>)

*Gambar {{2.x}} — Diagram alur {{ringkas alur yang digambarkan}}.*

<!-- Langkah: daftar bernomor. Percabangan pakai sub-butir (indentasi), BUKAN
     ASCII. Cantumkan titik validasi & pesan; selaraskan dengan 2.7. -->

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

<!-- Kutip pesan PERSIS seperti tampil di aplikasi. Pesan yang masih Inggris /
     tidak konsisten → catat apa adanya (temuan UAT). -->

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

<!-- Screenshot diambil via agent-browser (cara → SKILL.md §4). Simpan di
     ./images/ (boleh subfolder per menu), nama {{prefix}}-{topik}.png. -->

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

<!-- Satu baris per menu/modul terkait. Jelaskan arah & sifat keterkaitan dari
     sudut pandang bisnis. Rujuk bab terkait (mis. "lihat BAB III") atau master lain. -->

| Menu / Modul Terkait | Sifat Keterkaitan |
|---|---|
| {{Master Data / Referensi}} | {{Data referensi apa yang dipakai menu ini}} |
| {{Menu lain di modul ini (BAB ...)}} | {{Apa yang dibagikan / dipicu}} |
| Notifikasi | {{Kejadian yang memicu notifikasi, ke siapa}} |
| Audit Log | {{Lihat sub-bab 1.3.3 — perubahan pada menu ini tercatat}} |

---

<!-- LAMPIRAN TEKNIS BAB INI (2.10) — untuk dev & QA; ERD & endpoint IKUT ke klien. -->

## 2.10 Lampiran Teknis

Sub-bab ini ditujukan bagi tim pengembang & penguji. Memuat struktur data (ERD) dan kontrak endpoint yang menopang menu ini.

### 2.10.1 Struktur Tabel & Relasi (ERD)

Memperlihatkan tabel basis data ({{codebase.backend.db}}) yang dipakai menu ini beserta relasinya. Sumber kebenaran adalah migrasi & model backend (lihat `codebase.backend.migrations` dan `codebase.backend.models` pada doc-fsd.config.yml).

<!-- ERD = Mermaid `erDiagram` (BUKAN flowchart/gambar/tabel), disimpan ke
     ./images/{{prefix}}-erd.mmd lalu dirender ke .png. STANDAR SERAGAM lengkap
     (dua kategori tabel, styling hanya garis-tepi, kolom kunci, crow's foot)
     ada di SKILL.md §6 — ikuti persis. Kerangka .mmd baku:

erDiagram
    %% Garis tepi tebal brand = tabel UTAMA menu ini; abu tipis = tabel relasi.
    {{tabel_utama}} {
        bigint id PK
        bigint {{relasi}}_id FK "keterangan"
        string {{kolom_kunci}} "keterangan (mis. harus 'diposting')"
    }
    {{tabel_terkait}} {
        bigint id PK
        string name
    }
    {{tabel_terkait}} ||--o{ {{tabel_utama}} : "{{foreign_key}}"
    %% styling HANYA garis tepi — JANGAN fill/color (menutupi baris kolom di v11).
    style {{tabel_utama}} stroke:{{brand.color_primary}},stroke-width:3px
    style {{tabel_terkait}} stroke:#9AA7B4,stroke-width:1px
-->

![{{ERD menu}}](<./images/{{prefix}}-erd.png>)

*Gambar {{2.x}} — ERD menu {{Nama Menu}} (mermaid `erDiagram`). Tabel bergaris tepi tebal berwarna = tabel utama/inti menu ini; tabel bergaris tepi abu tipis = tabel relasi/terkait. Notasi crow's foot (`||--o{`) menandai relasi satu-ke-banyak.*

### 2.10.2 Referensi API/Endpoint

Kontrak endpoint yang menopang menu ini — acuan bagi developer & QA. Untuk Admin Panel (Inertia) umumnya berupa rute web yang mengembalikan halaman/aksi; untuk Applicant/TA Portal (Next.js) umumnya berupa endpoint API yang dikonsumsi frontend.

<!-- Satu baris per endpoint yang benar-benar dipakai menu ini. Sebut guard &
     capability (rujuk 1.3 & 2.5). Cukup parameter/field KUNCI. Selaraskan kolom
     "Terkait Fungsi" dengan ID pada 2.2. -->

| Method | Path / Rute | Guard · Capability | Tujuan | Parameter / Field Kunci | Terkait Fungsi |
|---|---|---|---|---|---|
| {{GET}} | {{/rute}} | {{auth:... · capability}} | {{Menampilkan daftar}} | {{page, q, filter[...]}} | {{PREFIX-01}} |
| {{POST}} | {{/rute}} | {{auth:... · capability}} | {{Menyimpan data baru}} | {{field wajib}} | {{PREFIX-04}} |
| {{PUT/PATCH}} | {{/rute/{id}}} | {{auth:... · capability}} | {{Mengubah data}} | {{field yang diubah}} | {{PREFIX-05}} |
| {{DELETE}} | {{/rute/{id}}} | {{auth:... · capability}} | {{Menghapus / menonaktifkan}} | {{id}} | {{PREFIX-06}} |

<!-- INTERNAL:START - sub-bab ini DIPANGKAS saat /fsd-convert; TIDAK ikut ke .docx klien -->
### 2.10.3 Matriks Keterlacakan (Traceability)

**(Internal — untuk audit tim; TIDAK disertakan pada dokumen klien `.docx`.)**

Setiap ID fungsi (2.2) dan aturan bisnis (2.4) dipetakan ke lokasi sumbernya di
kode — bukti bahwa dokumen ini menggambarkan perilaku nyata, bukan asumsi.

<!-- Satu baris per ID. Kolom Sumber = path relatif + baris tempat perilaku itu
     BENAR-BENAR ada. ID yang belum terbukti → "TIDAK TERVERIFIKASI" + angkat ke
     developer. Bab hanya "Selesai" bila tabel ini tak menyisakan baris tanpa
     sumber yang belum ditandai. -->

| ID | Perilaku Singkat | Sumber (file:baris) | Status |
|---|---|---|---|
| {{PREFIX}}-01 | {{Melihat daftar ...}} | {{app/Http/Controllers/XController.php:42}} | Terverifikasi |
| {{PREFIX}}-04 | {{Menambah ...}} | {{app/Http/Requests/StoreXRequest.php:20}} | Terverifikasi |
| {{PREFIX}}-BR-01 | {{Nama tidak boleh ganda}} | {{database/migrations/2024_..._create_x.php (unique)}} | Terverifikasi |
| {{PREFIX}}-BR-05 | {{Notifikasi ...}} | {{—}} | TIDAK TERVERIFIKASI |
<!-- INTERNAL:END -->

---
---

<!-- === AKHIR POLA BAB MENU === Salin blok BAB II di atas untuk BAB III, IV, ...
     (satu per menu). Perbarui Daftar Isi & Peta Menu (1.4). -->
