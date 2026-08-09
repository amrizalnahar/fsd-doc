---
name: fsd-convert
description: >-
  Konversi dokumen FSD Markdown satu role atau scope lintas-role menjadi .docx
  ber-brand (salinan klien) memakai docx-kit (Pandoc + reference.docx). Mengisi
  metadata sampul dari config, membuat Daftar Isi otomatis, dan menamai output
  berpola FSD-Modul-{Scope}. Pakai saat diminta "konversi FSD ke .docx", "build
  docx FSD", atau /fsd-convert <role[,role...]>. Butuh doc-fsd.config.yml +
  dokumen .md hasil /fsd-doc. Prasyarat: Pandoc.
---

# fsd-convert — Konversi FSD .md → .docx ber-brand

Satu dari tiga skill FSD (bersama `fsd-init` dan `fsd-doc`). Skill ini berdiri
sendiri. Memakai `./docx-kit/` (di folder skill ini): Pandoc + `reference.docx`
ber-brand.

## Langkah 0 — Muat konteks (SELALU dulu)

1. Baca `doc-fsd.config.yml` dari `docs/tasks/fsd/` (lokasi baku; fallback root
   repo untuk config lama) untuk `project.*`, `brand.*`, `output.*`, dan `docx.*`.
   - Tidak ada → minta pengguna menjalankan `/fsd-init` lebih dulu.
2. **Validasi config (preflight).** Cari `validate-config.py` di skill
   `fsd-init` bersisian (mis. `../fsd-init/validate-config.py` relatif ke
   folder skill ini) dan jalankan `py validate-config.py <path-config>`.
   Gagal → hentikan, tampilkan pelanggaran, jangan lanjut konversi. Tak
   terpasang/tak ditemukan → lanjut tanpa gagal total, tapi tetap periksa
   manual: slug unik/URL-slug-like tanpa `--`, `docx.reference`/`output.docx_dir`
   relatif (bukan absolut/`..`).
3. Cek prasyarat **Pandoc** (`pandoc --version`). Tidak ada → hentikan dengan
   pesan cara instal (`winget install --id JohnMacFarlane.Pandoc`); jangan
   lanjut.
4. **Resolve role scope** memakai grammar yang sama dengan `/fsd-doc`:
   - Terima satu role (`admin-ta`) atau role-set (`admin-ta,applicant`), split
     koma, trim token, lalu tolak token kosong/duplikat/role tidak dikenal.
   - Cocokkan tiap token dengan `modules[].slug`, lalu urutkan **leksikografis
     berdasarkan slug** (bukan urutan `modules[]` config — tidak stabil sebagai
     identitas karena array itu bisa diedit ulang urutannya) agar input
     terbalik mengarah ke scope yang sama.
   - Bentuk `document_key`: satu role tetap slug lama; beberapa role digabung
     dengan `--` dalam urutan leksikografis, mis. `admin-ta--applicant`.
   - Sumber tidak ditemukan di key leksikografis, tapi ada dokumen lama dengan
     key hasil urutan `modules[]` lama → hentikan dan minta migrasi/rename
     eksplisit, jangan menebak sumber mana yang dimaksud.
5. Pastikan dokumen sumber ada:
   `{output.documents_dir}/fsd-{document_key}.md`. Bila metadata scope pada
   Markdown tersedia, role canonical di sana wajib cocok dengan selector;
   mismatch → hentikan dan minta migrasi eksplisit.

## Langkah konversi

Kerjakan pada **salinan** dokumen (biar master `.md` utuh untuk dibaca di
GitHub):

1. **Isi metadata YAML sampul** (blok `---` teratas) dari `project.*` + `brand.*`
   config: title, subtitle (`{Nama Scope} — {project.name}`), author, date.
   `{Nama Scope}` adalah title role tunggal atau gabungan title role canonical;
   jangan memakai urutan role dari prompt.
2. **Hapus blok "Daftar Isi" manual** — Word membuatnya otomatis via `--toc`;
   membiarkannya = Daftar Isi ganda.
3. **Blok INTERNAL dipangkas otomatis oleh `build-docx.ps1`.** Setiap blok yang
   diapit `<!-- INTERNAL:START … -->` … `<!-- INTERNAL:END -->` (mis. sub-bab
   **2.10.3 Matriks Keterlacakan** yang berisi peta `file:baris`) dihapus dari
   salinan sebelum dikonversi — tidak pernah sampai ke `.docx` klien. (ERD
   2.10.1 & Endpoint 2.10.2 tetap ikut karena berada di luar blok INTERNAL.)
   Skrip berhenti dengan error bila menemukan penanda tak berpasangan, jadi
   tidak perlu memangkas manual — tetapi tetap boleh dipangkas manual di
   salinan bila ingin memverifikasi hasil sebelum konversi.
4. **Pastikan semua diagram sudah PNG** (bukan `.mmd`) dan semua referensi
   gambar valid. `build-docx.ps1` memvalidasi setiap `![...](path)` lokal
   sebelum memanggil Pandoc dan **gagal (fail-fast)** dengan daftar path yang
   hilang — bukan diam-diam mengganti gambar dengan teks alt.
5. **Hitung nama output** dari `output.docx_name_pattern` dan teruskan lewat
   `-Out` ke `output.docx_dir` — jangan mengandalkan fallback nama bawaan skrip.
   Untuk satu role, `{Modul}` tetap slug Title-Case (mis. `admin-ta` →
   `Admin-Ta`). Untuk role-set, gunakan display scope canonical yang aman untuk
   nama file (mis. `admin-ta,applicant` → `Admin-Ta-Dan-Applicant`).
   **Bila `docx.reference` di config diisi**, resolve path-nya relatif terhadap
   folder config, validasi filenya ada, lalu teruskan lewat `-Reference`; bila
   kosong, skrip memakai `docx-kit/reference.docx` bawaan:

   ```powershell
   ./docx-kit/build-docx.ps1 <salinan.md> -Out {output.docx_dir}/FSD-Modul-Admin-Ta-Dan-Applicant.docx -TocDepth {docx.toc_depth} -Reference {docx.reference}
   ```

   `/fsd-convert admin-ta,applicant` hanya mengonversi satu Markdown canonical;
   ia tidak menggabungkan FSD single-role yang sudah ada.

6. Buka di Word; bila Daftar Isi belum terisi, klik kanan → **Update Field**.

> **Header tabel & Google Docs.** `build-docx.ps1` otomatis menjalankan
> `harden-table-headers.py` sesudah Pandoc: teks putih + latar brand pada baris
> header dibaking sebagai *direct formatting*. Tanpa ini, saat `.docx` diunggah ke
> Google Docs (yang mengabaikan *conditional formatting* gaya tabel), teks putih
> header berubah jadi hitam. Butuh Python + `python-docx`; bila tak ada, langkah ini
> dilewati dengan pesan — dokumen tetap benar di Word.

> **Ukuran & perataan gambar.** `build-docx.ps1` juga menjalankan `fit-images.py`:
> diagram Mermaid dirender skala tinggi (`mmdc -s 3`) agar tajam, tetapi Pandoc
> meng-embed pada ukuran native sehingga satu gambar bisa memenuhi satu halaman.
> Skrip membatasi *ukuran tampilan* saja (lebar ≤ area cetak, tinggi ≤ setengah
> halaman — atur via `--max-height-frac`/`--max-height-in`) dan memusatkan paragraf
> gambar; rasio & piksel PNG tetap utuh sehingga proporsional namun tak pecah saat
> diperlebar. Butuh Python + `python-docx`; bila tak ada, dilewati (dokumen tetap valid).

## Brand .docx

Warna/font `.docx` berasal dari `./docx-kit/reference.docx`. `reference.docx`
default sudah netral; **regenerasi hanya bila `brand.*` di config berubah**:

```powershell
py ./docx-kit/make-reference-docx.py   # cari config otomatis (naik dari cwd)
```

**Logo** (`brand.logo`) berbeda: Pandoc mengabaikan isi body `reference.docx`,
jadi logo tidak bisa ditempel lewat `make-reference-docx.py`. `build-docx.ps1`
menyisipkannya sendiri ke sampul sesudah Pandoc via `insert-logo.py`. Kosong =
tanpa logo (tidak error); diisi tapi file tidak ditemukan = **build gagal**
(bukan cuma warning), supaya salah path tidak diam-diam mengirim sampul klien
tanpa logo.

Butuh `pip install python-docx pyyaml`. Detail lengkap: `./docx-kit/README.md`.

## Batasan

- Skill ini hanya mengonversi dokumen yang sudah ada — **tidak menulis isi FSD**
  (itu tugas `/fsd-doc`) dan **tidak mengubah kode sumber** proyek.
- Semua nilai brand/nama/output diambil dari `doc-fsd.config.yml` — tidak ada
  yang di-hardcode di engine.
