---
name: fsd-convert
description: >-
  Konversi dokumen FSD Markdown satu modul menjadi .docx ber-brand (salinan
  klien) memakai docx-kit (Pandoc + reference.docx). Mengisi metadata sampul dari
  config, membuat Daftar Isi otomatis, dan menamai output berpola
  FSD-Modul-{Modul}. Pakai saat diminta "konversi FSD ke .docx", "build docx
  FSD", atau /fsd-convert <modul>. Butuh doc-fsd.config.yml + dokumen .md hasil
  /fsd-doc. Prasyarat: Pandoc.
---

# fsd-convert — Konversi FSD .md → .docx ber-brand

Satu dari tiga skill FSD (bersama `fsd-init` dan `fsd-doc`). Skill ini berdiri
sendiri. Memakai `./docx-kit/` (di folder skill ini): Pandoc + `reference.docx`
ber-brand.

## Langkah 0 — Muat konteks (SELALU dulu)

1. Baca `doc-fsd.config.yml` dari `docs/tasks/fsd/` (lokasi baku; fallback root
   repo untuk config lama) untuk `project.*`, `brand.*`, `output.*`, dan `docx.*`.
   - Tidak ada → minta pengguna menjalankan `/fsd-init` lebih dulu.
2. Cek prasyarat **Pandoc** (`pandoc --version`). Tidak ada → hentikan dengan
   pesan cara instal (`winget install --id JohnMacFarlane.Pandoc`); jangan
   lanjut.
3. Pastikan dokumen sumber ada: `{output.documents_dir}/fsd-{modul}.md`.

## Langkah konversi

Kerjakan pada **salinan** dokumen (biar master `.md` utuh untuk dibaca di
GitHub):

1. **Isi metadata YAML sampul** (blok `---` teratas) dari `project.*` + `brand.*`
   config: title, subtitle (`{Nama Modul} — {project.name}`), author, date.
2. **Hapus blok "Daftar Isi" manual** — Word membuatnya otomatis via `--toc`;
   membiarkannya = Daftar Isi ganda.
3. **Pangkas blok INTERNAL.** Hapus setiap blok yang diapit penanda
   `<!-- INTERNAL:START … -->` … `<!-- INTERNAL:END -->` (mis. sub-bab **2.10.3
   Matriks Keterlacakan** yang berisi peta `file:baris`). Ini artefak audit tim,
   **tidak untuk klien** — jangan ikut ke `.docx`. (ERD 2.10.1 & Endpoint 2.10.2
   tetap ikut.) Catatan: penanda ini komentar HTML yang juga dibuang Pandoc, jadi
   pemangkasan HARUS dilakukan di langkah ini pada salinan — bukan diandalkan ke
   Pandoc (yang hanya membuang penanda, bukan isinya).
4. **Pastikan semua diagram sudah PNG** (bukan `.mmd`); Pandoc meng-embed PNG.
5. **Hitung nama output** dari `output.docx_name_pattern` (`{Modul}` = slug →
   Title-Case, mis. `admin-ta` → `Admin-Ta`) dan teruskan lewat `-Out` ke
   `output.docx_dir` — jangan mengandalkan pemangkasan nama bawaan skrip:

   ```powershell
   ./docx-kit/build-docx.ps1 <salinan.md> -Out {output.docx_dir}/FSD-Modul-Admin-Ta.docx -TocDepth {docx.toc_depth}
   ```

6. Buka di Word; bila Daftar Isi belum terisi, klik kanan → **Update Field**.

## Brand .docx

Warna/font/logo `.docx` berasal dari `./docx-kit/reference.docx`. `reference.docx`
default sudah netral; **regenerasi hanya bila `brand.*` di config berubah**:

```powershell
py ./docx-kit/make-reference-docx.py   # cari config otomatis (naik dari cwd)
```

Butuh `pip install python-docx pyyaml`. Detail lengkap: `./docx-kit/README.md`.

## Batasan

- Skill ini hanya mengonversi dokumen yang sudah ada — **tidak menulis isi FSD**
  (itu tugas `/fsd-doc`) dan **tidak mengubah kode sumber** proyek.
- Semua nilai brand/nama/output diambil dari `doc-fsd.config.yml` — tidak ada
  yang di-hardcode di engine.
