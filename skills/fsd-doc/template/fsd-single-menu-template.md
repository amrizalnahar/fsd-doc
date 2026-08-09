---
# METADATA SAMPUL (.docx) — isi placeholder sebelum konversi.
# Metadata ini digunakan katalog /fsd-doc; jangan hapus tanpa migrasi eksplisit.
title: "Functional Specification Document"
subtitle: "{{Nama Menu}} — {{project.name}}"
author:
  - "Versi {{1.0}}"
  - "Disusun oleh {{project.vendor}} untuk {{project.client}}"
date: "{{DD Bulan YYYY}}"
lang: "{{project.language}}"
status: "Menggambarkan fungsi yang sudah berjalan pada sistem"
document_type: "single-menu"
scope_key: "{{role_scope_key}}"
scope_roles:
  - "{{role-1}}"
  - "{{role-2 (hapus bila single-role)}}"
document_key: "{{role_scope_key}}--single-menu--{{target_key}}"
target_key: "{{target_key}}"
target_name: "{{Nama Menu}}"
document_title: "{{Nama Menu}}"
document_status: "Draf"
last_activity: "{{DD Bulan YYYY}} — Versi awal"
progress_summary: "{{Nama Menu}} — discovery/penyusunan awal (Draf)"
target_routes:
  - role: "{{role-1}}"
    route: "{{/rute-terverifikasi}}"
---

<!-- TEMPLATE FSD SINGLE MENU. Satu dokumen hanya untuk satu target menu. Metadata
     display (document_title/status/last_activity/progress_summary) diperbarui
     tiap sesi bersama sidecar agar launcher dapat menampilkan kartu ringkas.
     Split hanya bila discovery membuktikan varian role dari menu yang sama. -->

# Functional Specification Document — {{Nama Menu}}

**Aplikasi:** {{project.name}}
**Jenis dokumen:** Single Menu
**Scope role/portal:** {{Nama Scope}}
**Role canonical:** {{role-1[, role-2, ...]}}
**Rute per role:** {{role-1: /rute; role-2: /rute-bila-berbeda}}
**Versi dokumen:** {{1.0}}
**Tanggal:** {{DD Bulan YYYY}}
**Status:** Menggambarkan fungsi yang sudah berjalan pada sistem
**Perubahan versi ini:** {{Versi awal.}}

Dokumen ini menjelaskan spesifikasi fungsional **satu menu {{Nama Menu}}** pada
scope {{Nama Scope}} di {{project.name}}. Menu lain di luar scope, kecuali
keterkaitan yang terbukti pada BAB II.

---

## Daftar Isi

**BAB I — Informasi Umum Menu**

- 1.1 [Pendahuluan](#11-pendahuluan)
- 1.2 [Glosarium & Istilah](#12-glosarium--istilah)
- 1.3 [Peran & Hak Akses Umum](#13-peran--hak-akses-umum)

**BAB II — Menu: {{Nama Menu}}**

- 2.1 [Gambaran Umum & Posisi Menu](#21-gambaran-umum--posisi-menu)
- 2.2 [Daftar Fungsi](#22-daftar-fungsi)
- 2.3 [Data & Isian Formulir](#23-data--isian-formulir)
- 2.4 [Aturan Bisnis](#24-aturan-bisnis)
- 2.5 [Hak Akses & Cakupan Data](#25-hak-akses--cakupan-data)
- 2.6 [Alur Proses](#26-alur-proses)
- 2.7 [Pesan Sistem](#27-pesan-sistem)
- 2.8 [Antarmuka Pengguna](#28-antarmuka-pengguna)
- 2.9 [Keterkaitan dengan Menu Lain](#29-keterkaitan-dengan-menu-lain)
- 2.10 [Lampiran Teknis](#210-lampiran-teknis)

---
---

# BAB I — INFORMASI UMUM MENU

## 1.1 Pendahuluan

### 1.1.1 Tujuan Dokumen

Dokumen ini menjelaskan fungsi menu **{{Nama Menu}}** untuk {{role-1[, role-2]}}
pada {{project.name}}. Fokusnya adalah verifikasi fungsional/UAT: apa dan mengapa
sistem bekerja, bukan detail implementasi.

### 1.1.2 Ruang Lingkup

Termasuk posisi, fungsi, data, aturan, akses, alur, pesan, UI, ERD, endpoint, dan
traceability menu ini. Tidak termasuk menu lain, fitur tanpa sumber kode, serta
detail teknis di luar Lampiran Teknis.

## 1.2 Glosarium & Istilah

| Istilah | Definisi |
|---|---|
| **{{Istilah}}** | {{Definisi dari sudut pandang pengguna}} |

## 1.3 Peran & Hak Akses Umum

| Profil Akses / Role | Portal | Guard | Sesi & Cakupan Umum |
|---|---|---|---|
| {{role-1}} | {{frontend/backend}} | `{{guard}}` | {{syarat sesi dan cakupan terbukti}} |
| {{role-2 (opsional)}} | {{frontend/backend}} | `{{guard}}` | {{syarat sesi dan cakupan terbukti}} |

---
---

# BAB II — MENU: {{Nama Menu}}

| Metadata | Nilai |
|---|---|
| Prefix ID menu | `{{PREFIX}}` |
| Role / profil akses | {{role-1[, role-2, ...]}} |
| Keputusan scope | {{Unified / Hybrid / Split chapters, single document}} |
| Rute per role | {{role-1: /rute; role-2: /rute-bila-berbeda}} |

## 2.1 Gambaran Umum & Posisi Menu

**Posisi dalam aplikasi.** {{Lokasi navigasi, rute per role, dan kondisi kemunculan.}}

<!-- Source: path/relatif/file.ext:baris -->

**Konsep dasar.** {{Entitas utama, tujuan bisnis, dan prinsip penting dari sudut pengguna.}}

<!-- Source: path/relatif/file.ext:baris -->

## 2.2 Daftar Fungsi

| ID | Nama Fungsi | Role / Profil Berlaku | Keterangan |
|---|---|---|---|
| {{PREFIX}}-01 | {{Fungsi nyata}} | {{role}} | {{Keterangan}} |
<!-- Source: path/relatif/file.ext:baris -->

## 2.3 Data & Isian Formulir

| Field | W/O | Ketentuan Pengisian |
|---|---|---|
| **{{Nama Field}}** | W | {{Format, batas, dan validasi pengguna}} |
<!-- Source: path/relatif/file.ext:baris -->

## 2.4 Aturan Bisnis

| ID | Aturan | Role / Profil Berlaku | Penjelasan |
|---|---|---|---|
| {{PREFIX}}-BR-01 | **{{Aturan terverifikasi}}** | {{role}} | {{Penjelasan}} |
<!-- Source: path/relatif/file.ext:baris -->

## 2.5 Hak Akses & Cakupan Data

| Role / Profil | Menu | Rute Langsung | Cakupan Data | Widget / Field | Aksi | Penegakan & Bukti |
|---|---|---|---|---|---|---|
| {{role-1}} | {{tampil/sembunyi}} | {{izin/403/redirect}} | {{cakupan}} | {{elemen}} | {{aksi}} | {{guard/policy/query/API + Source}} |

## 2.6 Alur Proses

1. {{Role}} membuka {{Nama Menu}} pada `{{rute}}`. <!-- Source: path:baris -->
2. {{Langkah nyata}}. <!-- Source: path:baris -->
3. Sistem memvalidasi {{kondisi}} dan menampilkan "{{pesan persis}}" bila gagal. <!-- Source: path:baris -->
4. Sistem {{hasil}}. <!-- Source: path:baris -->

## 2.7 Pesan Sistem

| Kejadian | Pesan yang Ditampilkan | Bentuk |
|---|---|---|
| {{Kejadian}} | "{{pesan persis dari sumber}}" | {{notifikasi/dialog/teks}} |
<!-- Source: path/relatif/file.ext:baris -->

## 2.8 Antarmuka Pengguna

![{{Halaman utama}}](<{{path-relatif-ke-screenshot}}>)

*Gambar {{2.x}} — {{Role/profil}}: {{keterangan dari UI/screenshot}}.*

## 2.9 Keterkaitan dengan Menu Lain

| Menu / Scope Terkait | Sifat Keterkaitan |
|---|---|
| {{Menu terkait}} | {{Hubungan yang terbukti}} |
<!-- Source: path/relatif/file.ext:baris -->

## 2.10 Lampiran Teknis

### 2.10.1 Struktur Tabel & Relasi (ERD)

![{{ERD menu}}](<{{path-relatif-ke-erd}}>)

*Gambar {{2.x}} — ERD menu {{Nama Menu}}.*

### 2.10.2 Referensi API/Endpoint

| Role / Profil | Method | Path / Rute | Guard · Capability | Tujuan | Parameter / Field Kunci | Terkait Fungsi |
|---|---|---|---|---|---|---|
| {{role}} | {{GET/POST/...}} | {{/rute}} | {{guard/capability}} | {{Tujuan}} | {{parameter}} | {{PREFIX-01}} |
<!-- Source: path/relatif/file.ext:baris -->

<!-- INTERNAL:START -->
### 2.10.3 Matriks Keterlacakan (Traceability)

**(Internal — tidak disertakan pada dokumen klien `.docx`.)**

| ID | Role / Profil Berlaku | Perilaku Singkat | Sumber (file:baris) | Status |
|---|---|---|---|---|
| {{PREFIX}}-01 | {{role}} | {{Perilaku}} | {{path/file.ext:baris}} | Terverifikasi |
| {{PREFIX}}-BR-01 | {{role}} | {{Aturan}} | {{path/file.ext:baris}} | Terverifikasi |
<!-- INTERNAL:END -->
