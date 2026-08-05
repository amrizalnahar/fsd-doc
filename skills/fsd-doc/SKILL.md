---
name: fsd-doc
description: >-
  Tulis atau lanjutkan Functional Specification Document (FSD) satu modul
  langsung dari codebase — satu file .md per modul, satu BAB per menu. Menyusun
  BAB dari template bawaan; mengambil ERD dari migrasi/model, screenshot dari app
  live (opsional via agent-browser), dan kontrak endpoint dari rute. Pakai saat
  diminta membuat/melanjutkan FSD, "dokumentasi fungsional", "spesifikasi fitur
  untuk UAT", atau /fsd-doc <modul> "<Nama Menu>". Butuh doc-fsd.config.yml —
  bila belum ada, jalankan /fsd-init dulu. Konversi ke .docx: /fsd-convert.
---

# fsd-doc — Generator FSD (mode utama)

Satu dari tiga skill FSD (bersama `fsd-init` dan `fsd-convert`). Skill ini
berdiri sendiri. Satu dependensi opsional: `agent-browser` (untuk screenshot;
yang dimaksud adalah agent-browser dari <https://agent-browser.dev/snapshots>).
`mermaid-cli` (`mmdc`) opsional untuk render diagram — yang hilang tidak
menggagalkan total; degrade dan catat ke pengguna.

## Langkah 0 — Muat konteks (SELALU dulu)

1. Baca `doc-fsd.config.yml` dari `docs/tasks/fsd/` (lokasi baku; fallback root
   repo untuk config lama).
   - Tidak ada → hentikan dan minta pengguna menjalankan `/fsd-init` lebih dulu
     (jangan menebak nilai proyek).
2. Baca template: `./template/fsd-master-template.md` (di folder skill ini).
   - Bila proyek punya `docs/tasks/fsd/template.override.md`, pakai itu sebagai
     ganti template bawaan (lihat bagian Override).
3. Prasyarat yang hilang → JANGAN gagal total; degrade (lewati langkah terkait)
   dan catat ke pengguna.

## Prinsip FSD

Jelaskan **APA** yang sistem lakukan dan **MENGAPA** (untuk verifikasi
fungsional/UAT), **bukan** cara membangunnya. Detail teknis hanya di sub-bab
"Lampiran Teknis" tiap BAB.

Struktur: **satu file `.md` = satu modul**; **BAB I** diisi sekali; **BAB II,
III, …** satu per menu. Kerjakan **sekuensial & tuntas per BAB** sebelum menu
berikut.

## Aturan #1 — Dokumentasikan realita, bukan asumsi

FSD ini menggambarkan **fungsi yang SUDAH berjalan pada sistem**, bukan khayalan.
Aturan ini **mengalahkan** semua langkah lain di bawah. Jangan menulis apa pun
yang belum kamu lihat di kode.

1. **Baca kode dulu, tulis kemudian.** Telusuri implementasi nyata — rute,
   controller/handler, model, migrasi, request/validasi, komponen frontend,
   string pesan/i18n, config — SEBELUM menulis satu kalimat pun tentangnya.
2. **Setiap klaim wajib berdasar sumber.** Tandai asal tiap perilaku (fungsi,
   aturan bisnis, field, pesan, langkah alur) dengan komentar sumber tepat di
   dekat klaimnya: `<!-- Source: path/relatif/file.ext:baris -->`. Kalau kamu
   tidak menemukannya di kode, **jangan menuliskannya**.
3. **Jangan pernah mendokumentasikan perilaku yang DIRENCANAKAN / akan datang
   seolah sudah ada.** Fitur yang di-`TODO`, dikomentari, di belakang feature-flag
   mati, atau belum ter-*wire* → hilangkan dari dokumen; sarankan developer
   merencanakannya terpisah.
4. **Bila kode bertentangan dengan kata developer/PRD, dokumentasikan yang
   DILAKUKAN KODE**, lalu tandai ketidaksesuaian itu ke developer — jangan diam-
   diam mengikuti narasi yang salah.
5. **Jangan ubah kode sumber.** Membaca wajib; mengubah dilarang. Tulisan hanya
   ke folder `output.*` (dokumen, diagram, screenshot).

### Alur wajib: petakan sumber SEBELUM mengisi sub-bab

Untuk tiap menu, sebelum menyentuh sub-bab 2.1–2.9:

- **Bangun peta sumber menu:** temukan artefak konkretnya dan catat `file:baris`
  — rute/endpoint, handler/controller, model + migrasi, validasi/form-request,
  komponen UI, dan string pesan (i18n/komponen). Ini bahan mentah semua sub-bab.
- **Sumber tidak ditemukan → JANGAN mengarang.** Isi sub-bab/baris terkait dengan
  penanda `> **TIDAK TERVERIFIKASI** — <apa yang kurang / perlu dikonfirmasi>`
  dan tanyakan developer. Kosong lebih baik daripada plausibel-tapi-salah.
- **Teks harfiah dikutip PERSIS dari sumber**, bukan diparafrase dari ingatan:
  pesan sistem (2.7), label & opsi layar (2.3), teks tombol/konfirmasi (2.8).
- **Antarmuka (2.8):** deskripsi elemen berasal dari komponen nyata dan/atau
  screenshot live. Tanpa `agent-browser`, pakai placeholder + catatan — **jangan
  mengarang tata letak atau elemen**.
- **ERD & endpoint (2.10):** hanya dari migrasi/model & definisi rute yang nyata
  (bukan konvensi REST umum), lalu isi Matriks Keterlacakan (2.10.3).

**Gerbang verifikasi.** Sebuah BAB menu boleh berstatus **Selesai** di Peta Menu
(1.4) HANYA bila setiap klaimnya tertaut sumber (komentar `Source:`) atau
ditandai `TIDAK TERVERIFIKASI`. Selama masih ada kalimat tanpa dasar → **Draf**.

> Komentar `<!-- Source: … -->` hidup di master `.md` (terlihat di GitHub untuk
> audit/keterlacakan) dan **otomatis hilang** saat `/fsd-convert` (Pandoc membuang
> komentar HTML) — jadi dokumen `.docx` klien tetap bersih.

## 1. Tentukan target file

Nama file diturunkan dari `<modul>` (slug pada `modules[]`):
`{output.documents_dir}/fsd-{slug}.md`.

> **Konvensi `<modul>` = role/portal.** Satu modul umumnya setara satu **role /
> portal pengguna** (mis. `admin-ta`, `applicant`, `public`), masing-masing
> dijaga guard/role tersendiri (`modules[].guard`). Jadi `<modul>` boleh dibaca
> sebagai **nama role** — dokumen FSD-nya mencakup seluruh menu yang diakses role
> itu, dan screenshot memakai kredensial peran yang sama.

- File belum ada → buat baru; isi **BAB I** dari template lalu **BAB II** untuk
  menu yang diminta.
- File sudah ada → **baca dulu**, tambahkan menu sebagai **BAB baru** (naikkan
  nomor BAB & sub-bab), **jangan ubah BAB I atau bab menu sebelumnya**. Perbarui
  Daftar Isi + Peta Menu (sub-bab 1.4). Jaga konsistensi istilah & konvensi ID
  dengan bab sebelumnya.

## 2. Konvensi ID (dari template)

- Fungsi: `{PREFIX}-01`, `{PREFIX}-02`, … (mis. `SV-01`).
- Aturan bisnis: `{PREFIX}-BR-01`, … Pilih `{PREFIX}` pendek per menu, daftarkan
  di Peta Menu (1.4). Prefix harus unik antar-menu dalam satu modul.

## 3. Susun BAB menu (pola BAB II template)

Isi sub-bab 2.1–2.9 dari **peta sumber** (lihat Aturan #1), menelusuri perilaku
nyata fitur di codebase: gambaran umum, daftar fungsi, data & isian formulir,
aturan bisnis, hak akses khusus menu, alur proses, pesan sistem, antarmuka,
keterkaitan menu lain. Bahasa: sesuai `project.language` (default `id`).

Tiap baris fungsi (2.2), aturan bisnis (2.4), field (2.3), pesan (2.7), dan
langkah alur (2.6) membawa komentar `<!-- Source: file:baris -->`. Yang tak
bersumber tidak ditulis — tandai `TIDAK TERVERIFIKASI` dan tanya developer.

## 4. Screenshot (opsional — butuh `agent-browser`)

> Pengecekan `agent-browser`: yang dimaksud adalah agent-browser di
> <https://agent-browser.dev/snapshots>. Bila skill itu tidak terpasang, lewati
> langkah ini (lihat degradasi di akhir 4.2).

> **Instalasi agar terlihat Claude Code (WAJIB pakai flag).** `npx skills add`
> menaruh skill di canonical `.agents/skills/`, sedangkan Claude Code hanya
> memindai `.claude/skills/`. Junction ke `.claude/skills/` **hanya** dibuat bila
> Claude Code dipilih sebagai target. Jadi pasang deterministik:
>
> ```bash
> # global (semua project), target Claude Code, tanpa prompt:
> npx skills add vercel-labs/agent-browser -g -a claude-code -y
> # per-project: hilangkan -g (jalankan dari root project)
> ```
>
> Tanpa `-a claude-code`, skill terpasang tapi **tak terlihat** Claude Code →
> screenshot dilewati. Windows aman: CLI memakai junction (tak butuh admin).
> Verifikasi: `agent-browser --version` dan pastikan `agent-browser` muncul di
> daftar skill sesi baru. Bila terlanjur ter-install tanpa flag, jembatani:
> `New-Item -ItemType Junction -Path "$env:USERPROFILE\.claude\skills\agent-browser" -Target "$env:USERPROFILE\.agents\skills\agent-browser"`.

### 4.1 Siapkan kredensial (tanya bila belum ada, lalu simpan & pakai ulang)

Kredensial login per peran tinggal di `modules[].credentials` (mis.
`docs/tasks/credentialRoles/<peran>.md`) dan **dipakai ulang** antar-menu &
antar-sesi — hanya ditanyakan sekali.

1. **File kredensial peran itu ADA & lengkap** → baca, pakai. Jangan tanya lagi.
2. **Belum ada / tidak lengkap** → TANYA pengguna (satu pertanyaan per topik),
   lalu tulis ke `docs/tasks/credentialRoles/<peran>.md`:
   - **URL login** (bila beda dari `runtime.target_url`) **+** URL/menu target
     awal setelah login.
   - **Identitas**: field yang dipakai (email/username) beserta nilainya.
   - **Password**.
   - **Langkah khusus** (opsional): mis. teks tombol "Masuk", OTP/2FA dari mana,
     pilih tenant/role, dsb.

**Keamanan (WAJIB sebelum menulis file kredensial):** file ini berisi rahasia
teks-biasa. Pastikan `docs/tasks/credentialRoles/` sudah ada di `.gitignore`
proyek (tambahkan bila belum) **SEBELUM** menyimpan, agar kredensial tidak
ter-commit. Pakai **akun uji/staging**, bukan akun produksi. Jangan pernah
menaruh kredensial di dokumen FSD atau di `doc-fsd.config.yml`.

Format `docs/tasks/credentialRoles/<peran>.md`:

```markdown
# Kredensial peran: <peran>  (RAHASIA — jangan commit)

- Modul/peran : <judul modul> (<guard>)
- URL login   : <url>
- URL target  : <url/menu awal setelah login>
- Identitas   : <email|username> = <nilai>
- Password    : <nilai>
- Langkah     : <langkah khusus / OTP / kosong>
- Lingkungan  : uji/staging (bukan produksi)
```

### 4.2 Ambil screenshot

- **LANGKAH PERTAMA — set viewport desktop lebar SEBELUM login/navigasi/capture.**
  Pakai `runtime.viewport` (baku `1440x900`). Ini WAJIB dan bukan langkah opsional:
  viewport sempit memicu layout mobile/overlay sehingga sidebar `fixed` menutupi
  konten (label kiri terpotong). Set sekali di awal sesi; viewport bertahan antar-
  menu, **jangan** menunggu screenshot pertama gagal lalu recapture.
  - Contoh (agent-browser): `browser_set_viewport 1440 900` (atau parameter
    width/height sesuai skill) sebelum `browser_navigate`.
- Login ke URL memakai kredensial di atas, buka menu.
- Ambil screenshot; simpan ke
  `{output.screenshots_dir}/{modul}/{menu-slug}/{prefix}-{topik}.png`.
- **Bila sidebar MASIH menutupi konten** meski viewport sudah 1440 lebar
  (mis. sidebar aplikasi memang butuh ruang lebih): naikkan lebar (mis. `1600x900`
  atau `1920x1080`) lalu capture ulang, dan **perbarui `runtime.viewport` di config**
  agar menu berikutnya tidak mengulang masalah yang sama.
- `agent-browser` tidak terpasang → lewati langkah ini, sisipkan placeholder
  gambar + catatan "screenshot belum diambil (agent-browser tidak tersedia)".

## 5. Diagram alur (Mermaid → PNG)

- Tulis sumber sebagai `.mmd` ke `{output.diagrams_dir}/{modul}/{menu}/…`.
- Render: `mmdc -i <file>.mmd -o <file>.png -b {mermaid.background} -s {mermaid.scale}`.
- `mmdc` tak ada → simpan `.mmd` saja + catat perlu render manual.

## 6. Lampiran Teknis (sub-bab .10) — ikut diserahkan ke klien

- **ERD (.10.1):** baca `codebase.backend.migrations` & `.models` sebagai sumber
  kebenaran. Tulis Mermaid `erDiagram` (WAJIB `erDiagram`, bukan flowchart) ke
  `.mmd`, render ke PNG. **Standar seragam (lihat template 2.10.1):** dua kategori
  tabel dibedakan HANYA lewat garis tepi — tabel UTAMA/INTI menu di-highlight
  `stroke:{brand.color_primary},stroke-width:3px`, tabel RELASI/terkait standar
  `stroke:#9AA7B4,stroke-width:1px`. **JANGAN** pakai `fill:`/`color:` pada entitas
  (menutupi baris kolom di mermaid v11). Isi kolom KUNCI (PK/FK + kolom yang
  dipakai) saja.
- **Endpoint (.10.2):** daftar rute/endpoint yang **benar-benar terdefinisi** di
  `codebase.backend.routes`/frontend (bukan tebakan konvensi REST); sebut guard &
  capability (dari `modules[].guard` + kode), selaraskan kolom "Terkait Fungsi"
  dengan Daftar Fungsi (2.2).
- **Matriks Keterlacakan (.10.3):** petakan tiap ID fungsi & aturan bisnis ke
  `file:baris` sumbernya (lihat template). Baris tanpa sumber = TIDAK
  TERVERIFIKASI, diangkat ke developer.

## 7. Perbarui pelacak

Update Daftar Isi + Peta Menu (1.4). Status **Selesai** hanya bila lolos
self-check (langkah 8). Selama ada yang belum diverifikasi → **Draf**.

## 8. Self-check (gerbang akhir sebelum "Selesai")

Sebelum menandai sebuah BAB **Selesai** di langkah 7, **baca ulang** BAB yang baru
ditulis/diperbarui dan pindai pelanggaran. Ini pengaman terakhir Aturan #1 —
periksa hanya BAB menu yang sedang digarap (bab sebelumnya sudah beku).

Cara praktis: untuk tiap baris `| {PREFIX}-NN | … |` pada Daftar Fungsi (2.2) dan
Aturan Bisnis (2.4), pastikan syarat di bawah terpenuhi.

1. **Sitasi tiap klaim.** Setiap baris fungsi (2.2), aturan bisnis (2.4), pesan
   (2.7), dan langkah alur bervalidasi (2.6) punya komentar
   `<!-- Source: file:baris -->` di dekatnya **atau** penanda `TIDAK
   TERVERIFIKASI`. Baris tanpa keduanya = **GAGAL**.
2. **Matriks Keterlacakan lengkap (2.10.3).** Setiap ID di 2.2 & 2.4 muncul di
   tabel 2.10.3; kolom Sumber tidak boleh kosong tanpa ditandai `TIDAK
   TERVERIFIKASI`. ID yang ada di 2.2/2.4 tapi hilang dari 2.10.3 = **GAGAL**.
3. **Teks harfiah bukan karangan.** Pesan/label/tombol yang dikutip berasal dari
   sumber (i18n/komponen) yang tercatat, bukan parafrase dari ingatan. Ragu →
   tandai `TIDAK TERVERIFIKASI`.
4. **Tidak ada placeholder tersisa.** Tak ada `{{…}}` atau baris "(contoh —
   ganti)" yang belum diganti pada BAB yang diklaim selesai.
5. **Gambar sudah PNG / tercatat.** Diagram & ERD sudah dirender ke `.png` (atau,
   bila `mmdc` tak ada, `.mmd` tersimpan + dicatat perlu render manual);
   screenshot ada, atau ber-placeholder dengan catatan `agent-browser`.

Hasil:
- **Semua lolos** → BAB boleh berstatus **Selesai** (langkah 7).
- **Ada GAGAL** → status tetap **Draf**. Tampilkan ke pengguna daftar baris yang
  melanggar (ID + alasan) dan hal yang perlu dikonfirmasi ke developer. **Jangan**
  menandai Selesai dan **jangan** menambal celah dengan tebakan.

## Override template

Kalau sebuah proyek butuh struktur BAB berbeda, JANGAN salin seluruh template.
Buat `docs/tasks/fsd/template.override.md` di repo proyek; skill memakainya bila
ada, selain itu pakai `./template/fsd-master-template.md` bawaan.

## Batasan

- **Dokumentasikan realita, bukan asumsi** (Aturan #1): tanpa sumber di kode,
  jangan ditulis; perilaku terencana/belum-jadi tidak dimasukkan; bila kode ≠
  narasi developer, ikuti kode & tandai ketidaksesuaiannya.
- Skill **tidak mengubah kode sumber** proyek. Ia hanya membaca codebase &
  menulis dokumen/gambar di folder `output.*`.
- Jangan memanggil skill lain kecuali `agent-browser` (opsional, untuk
  screenshot).
- Semua nilai spesifik proyek diambil dari config — jangan meng-hardcode brand,
  path, guard, atau URL di dokumen kecuali memang nilai final proyek tersebut.
- Konversi `.md` → `.docx` bukan tugas skill ini — gunakan `/fsd-convert <modul>`.
