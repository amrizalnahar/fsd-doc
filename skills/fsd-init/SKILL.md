---
name: fsd-init
description: >-
  Bootstrap konfigurasi doc-fsd untuk sebuah proyek — mendeteksi framework &
  path dari repo, menanyakan sisa (nama proyek, klien, URL app, daftar modul +
  guard + kredensial), lalu menulis doc-fsd.config.yml dan membuat folder
  output. Pakai saat memulai FSD di proyek baru: "inisialisasi FSD", "setup
  doc-fsd", atau /fsd-init. Setelah ini, tulis dokumen dengan /fsd-doc dan
  konversi ke .docx dengan /fsd-convert.
---

# fsd-init — Bootstrap konfigurasi FSD

Satu dari tiga skill FSD (bersama `fsd-doc` dan `fsd-convert`). Skill ini berdiri
sendiri; tidak memanggil skill lain. Tujuannya: menghasilkan
`doc-fsd.config.yml` yang valid + folder output, dengan wawancara seminimal
mungkin.

## Model mental (berlaku untuk ketiga skill)

- **Engine** = ketiga skill FSD (instruksi + template + docx-kit). Dipasang
  sekali, dipakai di proyek mana pun.
- **Config** = `doc-fsd.config.yml` di dalam workspace FSD proyek
  (`docs/tasks/fsd/`), **bukan di root repo klien**. Semua nilai spesifik proyek
  (brand, path codebase, guard, URL, modul) ada di sini — tidak ada nilai proyek
  yang di-hardcode di engine.
- **Artefak** = dokumen `.md`/`.docx` + gambar. Lahir & tinggal di repo proyek.

Aturan emas: **yang sama di semua proyek → di engine; yang beda per proyek → di
config/artefak.**

## Langkah

1. **Cek config yang sudah ada.** Cari `doc-fsd.config.yml` di `docs/tasks/fsd/`
   (lokasi baku; cek juga root repo untuk config lama). Bila sudah ada → JANGAN
   menimpa tanpa konfirmasi eksplisit; tawarkan memperbarui field yang kurang saja.
2. **Deteksi otomatis sebisanya:**
   - Framework backend/frontend (cari `composer.json`+`artisan` → Laravel;
     `next.config.*` → Next.js; `manage.py` → Django; dll). Isi `codebase.*`.
   - Path migrasi/model (mis. `*/database/migrations`, `*/app/Models`).
   - Warna brand bila ada design token / skin (cari file tema/warna primer).
3. **Tanyakan HANYA yang tidak bisa dideteksi:** nama proyek, vendor, klien, URL
   app live, daftar role/portal + guard + lokasi kredensial. Satu pertanyaan per
   topik. Untuk setiap role, pastikan `slug` unik/stabil (URL-slug-like, tanpa
   `--`), title, portal, guard, dan placeholder path kredensial tersedia.
4. **Tulis `doc-fsd.config.yml`** memakai `./doc-fsd.config.example.yml` (di
   folder skill ini) sebagai acuan field/skema. **Simpan di dalam workspace FSD:
   `docs/tasks/fsd/doc-fsd.config.yml` — JANGAN di root repo klien** agar tidak
   mengotori repo utama. Buat folder `docs/tasks/fsd/` bila belum ada.
5. **Validasi config yang baru ditulis** — jalankan
   `py ./validate-config.py <path-config>` (di folder skill ini, preflight
   deterministik: slug unik/URL-slug-like, tanpa `--`, path `output.*`/
   `credentials`/`docx.reference`/`brand.logo` relatif & aman, warna brand
   `#RRGGBB`, dll). **Gagal** → perbaiki field yang ditunjuk sebelum lanjut ke
   langkah 6; jangan biarkan config tak valid tersimpan sebagai config final.
   Python/PyYAML tak ada → catat ke pengguna bahwa validasi dilewati, tetap
   sampaikan aturan skema utama secara manual.
6. **Buat folder output** dari `output.*` (documents, diagrams, screenshots,
   docx) — semuanya bersarang di bawah `docs/tasks/fsd/`, sehingga seluruh
   artefak FSD terkumpul di satu folder, tidak tercecer di root repo.

Catatan path: nilai `codebase.*` dan `output.*` di config tetap ditulis relatif
terhadap **root repo** (mis. `backend/…`, `docs/tasks/fsd/documents/…`), meski
file config-nya sendiri berada di `docs/tasks/fsd/`.
7. **Arahkan langkah berikutnya:** setelah config siap, jalankan
   `/fsd-doc <role[,role...]>` untuk memilih FSD Single Menu, Parent Menu/Modul,
   atau dokumen yang sudah ada. Command kompatibel
   `/fsd-doc <role[,role...]> "<Nama Menu>"` tetap membuat/melanjutkan FSD
   scope multi-menu legacy. Jangan membuat entry `modules[]` seperti
   `admin-ta,applicant`; role-set selalu dipilih saat command dipanggil.

## Catatan

- Skill ini **tidak mengubah kode sumber** proyek — hanya membaca repo untuk
  deteksi lalu menulis config + folder.
- Bila prasyarat sistem (Pandoc, mermaid-cli, agent-browser) belum terpasang,
  init tetap berhasil — prasyarat baru relevan di `/fsd-doc` & `/fsd-convert`.
- **Kredensial (secrets) TIDAK dikumpulkan di sini.** Config hanya menyimpan
  *lokasi* file kredensial per modul (`modules[].credentials`, mis.
  `docs/tasks/credentialRoles/<peran>.md`). Isi kredensial (URL login, identitas,
  password) baru ditanyakan `/fsd-doc` saat pertama kali screenshot lalu disimpan
  di file itu; folder `docs/tasks/credentialRoles/` di-gitignore. Jangan menaruh
  secrets di config.
