---
# METADATA SAMPUL (.docx) — isi placeholder sebelum konversi.
# Metadata berikut adalah dasar katalog /fsd-doc; jangan menghapusnya tanpa
# migrasi eksplisit karena skill memakainya untuk deteksi dokumen yang sudah ada.
title: "Functional Specification Document"
subtitle: "{{Nama Parent Menu/Modul}} — {{project.name}}"
author:
  - "Versi {{1.0}}"
  - "Disusun oleh {{project.vendor}} untuk {{project.client}}"
date: "{{DD Bulan YYYY}}"
lang: "{{project.language}}"
status: "Menggambarkan fungsi yang sudah berjalan pada sistem"
document_type: "parent-module"
scope_key: "{{role_scope_key}}"
scope_roles:
  - "{{role-1}}"
  - "{{role-2 (hapus bila single-role)}}"
document_key: "{{role_scope_key}}--parent-module--{{target_key}}"
target_key: "{{target_key}}"
target_name: "{{Nama Parent Menu/Modul}}"
document_title: "{{Nama Parent Menu/Modul}}"
document_status: "Draf"
last_activity: "{{DD Bulan YYYY}} — Versi awal"
progress_summary: "0/1 submenu selesai — penyusunan awal (Draf)"
parent_status: "Draf"
submenu_progress:
  completed: 0
  draft: 1
  pending: 0
target_routes:
  - role: "{{role-1}}"
    route: "{{/rute-parent-terverifikasi}}"
child_menus:
  - key: "{{submenu-1-key}}"
    name: "{{Nama Submenu 1}}"
    routes:
      - role: "{{role-1}}"
        route: "{{/rute-submenu-1}}"
---

<!-- TEMPLATE FSD PARENT MENU/MODUL. Satu dokumen membahas satu parent/modul dan
     submenu yang dipilih. Parent bukan bukti perilaku submenu: discovery sumber,
     BAB menu, matriks akses, lampiran teknis, dan traceability tetap diwajibkan
     untuk setiap submenu. Perbarui metadata display (document_title/status,
     last_activity, progress_summary, parent_status, submenu_progress) bersama
     sidecar setiap sesi agar launcher dapat menampilkan progres ringkas. -->

# Functional Specification Document — {{Nama Parent Menu/Modul}}

**Aplikasi:** {{project.name}}
**Jenis dokumen:** Parent Menu/Modul
**Scope role/portal:** {{Nama Scope}}
**Role canonical:** {{role-1[, role-2, ...]}}
**Parent menu/modul:** {{Nama Parent Menu/Modul}}
**Rute parent per role:** {{role-1: /rute-parent; role-2: /rute-bila-berbeda}}
**Versi dokumen:** {{1.0}}
**Tanggal:** {{DD Bulan YYYY}}
**Status:** Menggambarkan fungsi yang sudah berjalan pada sistem
**Perubahan versi ini:** {{Versi awal.}}

Dokumen ini menjelaskan parent menu/modul **{{Nama Parent Menu/Modul}}** dan
submenu yang tercantum pada Peta Submenu. Ia tidak mencakup menu di luar modul,
kecuali hubungan bisnis yang memang terbukti pada sumber.

---

## Daftar Isi

**BAB I — Informasi Umum Modul**

- 1.1 [Pendahuluan](#11-pendahuluan)
- 1.2 [Glosarium & Istilah](#12-glosarium--istilah)
- 1.3 [Peran & Hak Akses Umum](#13-peran--hak-akses-umum)
- 1.4 [Peta Submenu & Pelacak Progres](#14-peta-submenu--pelacak-progres)

**BAB II — Parent Menu/Modul: {{Nama Parent Menu/Modul}}**

- 2.1 [Tujuan & Posisi Parent](#21-tujuan--posisi-parent)
- 2.2 [Struktur Navigasi & Submenu](#22-struktur-navigasi--submenu)
- 2.3 [Hak Akses & Cakupan Modul](#23-hak-akses--cakupan-modul)
- 2.4 [Alur & Keterkaitan Lintas-Menu](#24-alur--keterkaitan-lintas-menu)

**BAB III — Menu: {{Nama Submenu 1}}**

- 3.1 [Gambaran Umum & Posisi Menu](#31-gambaran-umum--posisi-menu)
- 3.2 [Daftar Fungsi](#32-daftar-fungsi)
- 3.3 [Data & Isian Formulir](#33-data--isian-formulir)
- 3.4 [Aturan Bisnis](#34-aturan-bisnis)
- 3.5 [Hak Akses & Cakupan Data](#35-hak-akses--cakupan-data)
- 3.6 [Alur Proses](#36-alur-proses)
- 3.7 [Pesan Sistem](#37-pesan-sistem)
- 3.8 [Antarmuka Pengguna](#38-antarmuka-pengguna)
- 3.9 [Keterkaitan dengan Menu Lain](#39-keterkaitan-dengan-menu-lain)
- 3.10 [Lampiran Teknis](#310-lampiran-teknis)

<!-- Tambah BAB IV, V, dst. dengan menyalin pola BAB submenu di bawah. Perbarui
     Daftar Isi, Peta Submenu (1.4), dan YAML child_menus pada setiap perubahan. -->

---
---

# BAB I — INFORMASI UMUM MODUL

## 1.1 Pendahuluan

### 1.1.1 Tujuan Dokumen

Dokumen ini menjelaskan fungsi parent menu/modul **{{Nama Parent Menu/Modul}}**
dan submenu terpilih untuk {{role-1[, role-2]}} di {{project.name}}. Fokusnya
adalah apa dan mengapa sistem bekerja untuk UAT, bukan cara implementasi.

### 1.1.2 Ruang Lingkup

Termasuk dalam ruang lingkup:

- Parent menu/modul, navigasi, dan akses tingkat modul yang terbukti.
- Semua submenu dalam Peta Submenu (1.4), masing-masing dengan BAB mandiri.
- Perbedaan role pada parent maupun setiap submenu yang didukung sumber kode.

Tidak termasuk:

- Submenu yang tidak ada pada Peta Submenu atau belum terbukti di kode.
- Menu/modul lain, kecuali hubungan yang dicatat pada BAB terkait.
- Detail teknis di luar Lampiran Teknis tiap submenu.

## 1.2 Glosarium & Istilah

| Istilah | Definisi |
|---|---|
| **{{Istilah lintas-modul}}** | {{Definisi dari sudut pandang pengguna}} |

## 1.3 Peran & Hak Akses Umum

| Profil Akses / Role | Portal | Guard | Sesi & Cakupan Umum |
|---|---|---|---|
| {{role-1}} | {{frontend/backend}} | `{{guard}}` | {{syarat sesi/cakupan terbukti}} |
| {{role-2 (opsional)}} | {{frontend/backend}} | `{{guard}}` | {{syarat sesi/cakupan terbukti}} |

{{Jelaskan model izin umum yang terbukti. Detail parent di 2.3 dan submenu di BAB masing-masing.}}

## 1.4 Peta Submenu & Pelacak Progres

<!-- Sinkron dengan YAML child_menus dan sidecar. Status: Belum / Draf / Selesai. -->

| Bab | Key | Submenu | Role / Profil Akses | Rute per Role | Prefix ID | Status Dokumentasi |
|---|---|---|---|---|---|---|
| III | {{submenu-1-key}} | {{Nama Submenu 1}} | {{role-1[, role-2]}} | {{role-1: /rute}} | {{SM1}} | {{Belum / Draf / Selesai}} |
| IV | {{submenu-2-key}} | {{Nama Submenu 2}} | {{role-1[, role-2]}} | {{role-1: /rute}} | {{SM2}} | {{Belum}} |

**Keterangan status:** *Belum* = belum digarap · *Draf* = ada klaim/pertanyaan
belum selesai · *Selesai* = semua klaim tertaut sumber atau diberi penanda
*TIDAK TERVERIFIKASI* serta lolos self-check.

---
---

# BAB II — PARENT MENU/MODUL: {{Nama Parent Menu/Modul}}

## 2.1 Tujuan & Posisi Parent

**Posisi dalam aplikasi.** Parent menu/modul berada pada {{lokasi navigasi}} dan
mengarahkan/menampilkan submenu {{Nama Submenu 1[, Submenu 2]}}. Rute parent per
role: {{role-1: /rute-parent; role-2: /rute-parent-bila-berbeda}}.

<!-- Source: path/relatif/file.ext:baris -->

**Tujuan modul.** {{Tujuan bisnis parent dan alasan submenu dikelompokkan.}}

<!-- Source: path/relatif/file.ext:baris -->

## 2.2 Struktur Navigasi & Submenu

| Submenu | Posisi / Label Navigasi | Rute per Role | Tujuan Ringkas | Bukti |
|---|---|---|---|---|
| {{Nama Submenu 1}} | {{label/urutan}} | {{role: /rute}} | {{Tujuan terbukti}} | {{file:baris}} |
| {{Nama Submenu 2}} | {{label/urutan}} | {{role: /rute}} | {{Tujuan terbukti}} | {{file:baris}} |

## 2.3 Hak Akses & Cakupan Modul

| Role / Profil | Parent/Modul | Rute Parent | Submenu Terlihat | Cakupan / Batas | Penegakan & Bukti |
|---|---|---|---|---|---|
| {{role-1}} | {{tampil/sembunyi}} | {{izin/403/redirect}} | {{daftar submenu}} | {{batas tingkat modul}} | {{guard/menu/policy + Source}} |
| {{role-2 (opsional)}} | {{tampil/sembunyi}} | {{izin/403/redirect}} | {{daftar submenu}} | {{batas}} | {{bukti}} |

## 2.4 Alur & Keterkaitan Lintas-Menu

1. {{Role}} membuka parent/modul. <!-- Source: path:baris -->
2. Sistem menampilkan submenu yang sesuai izin. <!-- Source: path:baris -->
3. Pengguna memilih {{submenu}} untuk menjalankan fungsi pada BAB terkait. <!-- Source: path:baris -->

| Menu / Scope Terkait | Sifat Keterkaitan |
|---|---|
| {{Modul/menu terkait}} | {{Data atau proses yang dibagikan}} |
<!-- Source: path/relatif/file.ext:baris -->

---
---

<!-- === POLA BAB SUBMENU — salin untuk BAB IV, V, dst. === -->
# BAB III — MENU: {{Nama Submenu 1}}

| Metadata | Nilai |
|---|---|
| Key submenu | `{{submenu-1-key}}` |
| Prefix ID menu | `{{PREFIX}}` |
| Role / profil akses | {{role-1[, role-2]}} |
| Keputusan scope | {{Unified / Hybrid / Split chapters, single document}} |
| Rute per role | {{role-1: /rute; role-2: /rute-bila-berbeda}} |

## 3.1 Gambaran Umum & Posisi Menu

**Posisi dalam modul.** Submenu ini berada di bawah **{{Nama Parent Menu/Modul}}**
pada {{lokasi navigasi}}, rute `{{/rute}}`, dan berlaku untuk {{role}}.

<!-- Source: path/relatif/file.ext:baris -->

**Konsep dasar.** {{Entitas utama dan tujuan bisnis submenu.}}

<!-- Source: path/relatif/file.ext:baris -->

## 3.2 Daftar Fungsi

| ID | Nama Fungsi | Role / Profil Berlaku | Keterangan |
|---|---|---|---|
| {{PREFIX}}-01 | {{Melihat daftar/detail}} | {{role}} | {{Keterangan}} |
<!-- Source: path/relatif/file.ext:baris -->
| {{PREFIX}}-02 | {{Menambah/mengubah/menghapus}} | {{role}} | {{Keterangan}} |
<!-- Source: path/relatif/file.ext:baris -->

## 3.3 Data & Isian Formulir

Notasi: **W** = wajib, **O** = opsional.

| Field | W/O | Ketentuan Pengisian |
|---|---|---|
| **{{Nama Field}}** | W | {{Ketentuan dari sudut pandang pengguna}} |
<!-- Source: path/relatif/file.ext:baris -->
| **{{Nama Field}}** | O | {{Ketentuan}} |
<!-- Source: path/relatif/file.ext:baris -->

## 3.4 Aturan Bisnis

| ID | Aturan | Role / Profil Berlaku | Penjelasan |
|---|---|---|---|
| {{PREFIX}}-BR-01 | **{{Aturan terverifikasi}}** | {{role}} | {{Penjelasan}} |
<!-- Source: path/relatif/file.ext:baris -->
| {{PREFIX}}-BR-02 | **{{Aturan lain}}** | {{role}} | {{Penjelasan}} |
<!-- Source: path/relatif/file.ext:baris -->

## 3.5 Hak Akses & Cakupan Data

| Role / Profil | Menu | Rute Langsung | Cakupan Data | Widget / Field | Aksi | Penegakan & Bukti |
|---|---|---|---|---|---|---|
| {{role-1}} | {{tampil/sembunyi}} | {{izin/403/redirect}} | {{cakupan data}} | {{elemen}} | {{aksi}} | {{guard/policy/query/API + Source}} |
| {{role-2 (opsional)}} | {{tampil/sembunyi}} | {{izin/403/redirect}} | {{cakupan data}} | {{elemen}} | {{aksi}} | {{bukti}} |

## 3.6 Alur Proses

### 3.6.1 {{Nama alur utama}}

1. {{Role}} membuka submenu pada `{{rute}}`. <!-- Source: path:baris -->
2. {{Langkah nyata}}. <!-- Source: path:baris -->
3. Sistem memvalidasi {{kondisi}}; bila gagal, tampilkan "{{pesan persis}}". <!-- Source: path:baris -->
4. Sistem {{hasil}}. <!-- Source: path:baris -->

## 3.7 Pesan Sistem

| Kejadian | Pesan yang Ditampilkan | Bentuk |
|---|---|---|
| {{Kejadian}} | "{{pesan persis}}" | {{notifikasi/dialog/teks}} |
<!-- Source: path/relatif/file.ext:baris -->

## 3.8 Antarmuka Pengguna

### 3.8.1 Halaman Utama — {{Role / Profil}}

![{{Halaman submenu}}](<{{path-relatif-ke-screenshot}}>)

*Gambar {{3.x}} — {{Role/profil}}: {{keterangan berbukti dari UI/screenshot}}.*

| Elemen | Perilaku |
|---|---|
| {{Komponen}} | {{Perilaku}} |
<!-- Source: path/relatif/file.ext:baris -->

## 3.9 Keterkaitan dengan Menu Lain

| Menu / Scope Terkait | Sifat Keterkaitan |
|---|---|
| {{Parent Menu/Modul}} | {{Hubungan submenu dengan parent}} |
| {{Menu terkait}} | {{Hubungan terbukti}} |
<!-- Source: path/relatif/file.ext:baris -->

## 3.10 Lampiran Teknis

### 3.10.1 Struktur Tabel & Relasi (ERD)

![{{ERD submenu}}](<{{path-relatif-ke-erd}}>)

*Gambar {{3.x}} — ERD submenu {{Nama Submenu 1}}.*

<!-- Mermaid wajib erDiagram. Styling: tabel utama
     stroke:{{brand.color_primary}},stroke-width:3px; tabel relasi
     stroke:#9AA7B4,stroke-width:1px; jangan pakai fill/color. -->

### 3.10.2 Referensi API/Endpoint

| Role / Profil | Method | Path / Rute | Guard · Capability | Tujuan | Parameter / Field Kunci | Terkait Fungsi |
|---|---|---|---|---|---|---|
| {{role}} | {{GET/POST/...}} | {{/rute}} | {{guard/capability}} | {{Tujuan}} | {{parameter}} | {{PREFIX-01}} |
<!-- Source: path/relatif/file.ext:baris -->

<!-- INTERNAL:START -->
### 3.10.3 Matriks Keterlacakan (Traceability)

**(Internal — tidak disertakan pada dokumen klien `.docx`.)**

| ID | Role / Profil Berlaku | Perilaku Singkat | Sumber (file:baris) | Status |
|---|---|---|---|---|
| {{PREFIX}}-01 | {{role}} | {{Perilaku}} | {{path/file.ext:baris}} | Terverifikasi |
| {{PREFIX}}-BR-01 | {{role}} | {{Aturan}} | {{path/file.ext:baris}} | Terverifikasi |
<!-- INTERNAL:END -->

<!-- === AKHIR POLA BAB SUBMENU === -->
