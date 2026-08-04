---
name: doc-fsd
description: >-
  Generate Functional Specification Documents (FSD) langsung dari sebuah
  codebase — satu dokumen per modul, satu BAB per menu — lalu konversi ke
  .docx ber-brand untuk klien/UAT. Membaca doc-fsd.config.yml proyek untuk
  brand, path codebase, guard, dan URL app; menyusun BAB dari template
  bawaan; mengambil ERD dari migrasi/model, screenshot dari app live
  (opsional via agent-browser), dan kontrak endpoint dari rute. Pakai saat
  diminta membuat/melanjutkan FSD, "dokumentasi fungsional", "spesifikasi
  fitur untuk UAT", atau konversi FSD ke .docx.
---

# doc-fsd — Functional Specification Document generator

Skill ini berdiri sendiri. Ia **tidak** memerlukan skill `tca-*` lain. Satu
dependensi opsional: `agent-browser` (untuk screenshot). Semua alat berat
(Pandoc, mermaid-cli) adalah prasyarat sistem — lihat `README.md`.

## Model mental

- **Engine** = skill ini (template + docx-kit + instruksi). Dipasang sekali,
  dipakai di proyek mana pun.
- **Config** = `doc-fsd.config.yml` di dalam repo proyek. Semua nilai spesifik
  proyek (brand, path codebase, guard, URL, modul) ada di sini — tidak ada nilai
  proyek yang di-hardcode di engine.
- **Artefak** = dokumen `.md`/`.docx` + gambar. Lahir & tinggal di repo proyek.

Aturan emas: **yang sama di semua proyek → di engine; yang beda per proyek →
di config/artefak.** Jangan pernah menyalin `template/` atau `docx-kit/` ke
dalam repo proyek.

## Mode

Skill dijalankan dalam salah satu mode. Kalau argumen tidak jelas, tanyakan.

| Mode | Perintah | Fungsi |
|---|---|---|
| `init` | `/doc-fsd init` | Bootstrap `doc-fsd.config.yml` + struktur folder proyek (wawancara gap saja). |
| `doc` | `/doc-fsd doc <modul> "<Nama Menu>"` | Buat/lanjutkan FSD satu modul: tambah BAB menu baru. Mode utama. |
| `build` | `/doc-fsd build <modul>` | Konversi `.md` modul → `.docx` ber-brand (salinan klien). |

Default bila hanya `/doc-fsd`: deteksi apakah config ada → kalau belum, jalankan
`init`; kalau sudah, tanyakan modul & menu untuk `doc`.

---

## Langkah 0 — Muat konteks (SELALU dulu)

1. Baca `doc-fsd.config.yml` dari root repo proyek (atau `docs/tasks/fsd/`).
   - Tidak ada → jalankan mode `init` (jangan lanjut sebelum config ada).
2. Baca template: `template/fsd-master-template.md` **dari paket skill ini**.
   - Bila proyek punya `docs/tasks/fsd/template.override.md`, pakai itu sebagai
     ganti template bawaan (mekanisme override; lihat bagian Override).
3. Validasi prasyarat sesuai mode (lihat tabel prasyarat di README). Yang hilang
   → JANGAN gagal total; degrade (lewati langkah terkait) dan catat ke pengguna.

---

## Mode `init`

Tujuan: menghasilkan `doc-fsd.config.yml` yang valid + folder output, dengan
wawancara seminimal mungkin (isi otomatis apa yang bisa dideteksi dari repo).

1. Deteksi otomatis sebisanya:
   - Framework backend/frontend (cari `composer.json`+`artisan` → Laravel;
     `next.config.*` → Next.js; dll). Isi `codebase.*`.
   - Path migrasi/model (mis. `*/database/migrations`, `*/app/Models`).
   - Warna brand bila ada design token / skin (cari file tema/warna primer).
2. Tanyakan HANYA yang tidak bisa dideteksi: nama proyek, vendor, klien, URL app
   live, daftar modul + guard + lokasi kredensial. Satu pertanyaan per topik.
3. Tulis `doc-fsd.config.yml` (pakai `doc-fsd.config.example.yml` sebagai acuan
   field). Buat folder output dari `output.*` (documents, diagrams, screenshots).
4. Jangan menimpa config yang sudah ada tanpa konfirmasi.

---

## Mode `doc` — inti generator

Prinsip FSD (dari template): jelaskan **APA** yang sistem lakukan dan **MENGAPA**
(untuk verifikasi fungsional/UAT), **bukan** cara membangunnya. Detail teknis
hanya di sub-bab "Lampiran Teknis" tiap BAB.

Struktur: **satu file `.md` = satu modul**; **BAB I** diisi sekali; **BAB II, III,
…** satu per menu. Kerjakan **sekuensial & tuntas per BAB** sebelum menu berikut.

### 1. Tentukan target file
Nama file diturunkan dari `<modul>` (slug pada `modules[]`):
`{output.documents_dir}/fsd-{slug}.md`.
- File belum ada → buat baru; isi **BAB I** dari template lalu **BAB II** untuk
  menu yang diminta.
- File sudah ada → **baca dulu**, tambahkan menu sebagai **BAB baru**
  (naikkan nomor BAB & sub-bab), **jangan ubah BAB I atau bab menu sebelumnya**.
  Perbarui Daftar Isi + Peta Menu (sub-bab 1.4). Jaga konsistensi istilah &
  konvensi ID dengan bab sebelumnya.

### 2. Konvensi ID (dari template)
- Fungsi: `{PREFIX}-01`, `{PREFIX}-02`, … (mis. `SV-01`).
- Aturan bisnis: `{PREFIX}-BR-01`, … Pilih `{PREFIX}` pendek per menu, daftarkan
  di Peta Menu (1.4). Prefix harus unik antar-menu dalam satu modul.

### 3. Susun BAB menu (pola BAB II template)
Isi sub-bab 2.1–2.9 dengan menelusuri perilaku nyata fitur di codebase:
gambaran umum, daftar fungsi, data & isian formulir, aturan bisnis, hak akses
khusus menu, alur proses, pesan sistem, antarmuka, keterkaitan menu lain.
Bahasa: sesuai `project.language` (default `id`).

### 4. Screenshot (opsional — butuh `agent-browser`)
- Login ke `runtime.target_url` memakai kredensial dari
  `modules[].credentials` (mis. `docs/tasks/credentialRoles/<peran>.md`).
- Ambil screenshot menu; simpan ke
  `{output.screenshots_dir}/{modul}/{menu-slug}/{prefix}-{topik}.png`.
- `agent-browser` tidak terpasang → lewati langkah ini, sisipkan placeholder
  gambar + catatan "screenshot belum diambil (agent-browser tidak tersedia)".

### 5. Diagram alur (Mermaid → PNG)
- Tulis sumber sebagai `.mmd` ke `{output.diagrams_dir}/{modul}/{menu}/…`.
- Render: `mmdc -i <file>.mmd -o <file>.png -b {mermaid.background} -s {mermaid.scale}`.
- `mmdc` tak ada → simpan `.mmd` saja + catat perlu render manual.

### 6. Lampiran Teknis (sub-bab .10) — ikut diserahkan ke klien
- **ERD (.10.1):** baca `codebase.backend.migrations` & `.models` sebagai sumber
  kebenaran. Tulis Mermaid `erDiagram` (WAJIB `erDiagram`, bukan flowchart) ke
  `.mmd`, render ke PNG. Highlight tabel INTI menu (warna `brand.color_primary`),
  tabel terkait abu. Isi kolom KUNCI (PK/FK + kolom yang dipakai) saja.
- **Endpoint (.10.2):** daftar rute/endpoint yang menopang menu; sebut guard &
  capability (dari `modules[].guard`), selaraskan kolom "Terkait Fungsi" dengan
  Daftar Fungsi (2.2).

### 7. Perbarui pelacak
Update Daftar Isi + Peta Menu (1.4): status menu → Draf/Selesai.

---

## Mode `build` — konversi ke .docx

Pakai `docx-kit/` dari paket skill (Pandoc + `reference.docx` ber-brand).
Sebelum konversi salinan klien, kerjakan pada **salinan** (biar master utuh):

1. Isi metadata YAML sampul (dari `project.*` + `brand.*` config).
2. Hapus blok "Daftar Isi" manual (Word bikin otomatis via `--toc`).
3. Pastikan semua diagram sudah PNG (bukan `.mmd`).
4. Hitung nama output dari `output.docx_name_pattern` (`{Modul}` = slug →
   Title-Case, mis. `admin-ta` → `Admin-Ta`) dan teruskan lewat `-Out` ke
   `output.docx_dir` — jangan mengandalkan pemangkasan nama bawaan skrip:
   `docx-kit/build-docx.ps1 <salinan.md> -Out {output.docx_dir}/FSD-Modul-Admin-Ta.docx -TocDepth {docx.toc_depth}`
5. Brand `.docx` (warna/font/logo) berasal dari `reference.docx`; regenerasi
   hanya bila `brand.*` berubah (lihat docx-kit/README).

---

## Override template

Kalau sebuah proyek butuh struktur BAB berbeda, JANGAN salin seluruh template.
Buat `docs/tasks/fsd/template.override.md` di repo proyek; skill memakainya bila
ada, selain itu pakai `template/fsd-master-template.md` bawaan. Ini menjaga satu
sumber untuk template default sambil mengizinkan penyesuaian per proyek.

## Batasan

- Skill **tidak mengubah kode sumber** proyek. Ia hanya membaca codebase &
  menulis dokumen/gambar di folder `output.*`.
- Jangan memanggil skill lain kecuali `agent-browser` (opsional, untuk
  screenshot). Tidak memanggil `tca-init`/`tca-doc`.
- Semua nilai spesifik proyek diambil dari config — jangan meng-hardcode brand,
  path, guard, atau URL di dokumen kecuali memang nilai final proyek tersebut.
