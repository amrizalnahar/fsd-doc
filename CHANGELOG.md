# Changelog

Semua perubahan penting doc-fsd dicatat dalam dokumen ini.

Format mengacu pada [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
dan project memakai [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Launcher `/fsd-doc <role[,role...]>` untuk memilih FSD **Single Menu**,
  **Parent Menu/Modul**, membuka dokumen yang ada, atau mengelola FSD scope
  multi-menu legacy.
- Template bawaan terpisah untuk Single Menu dan Parent Menu/Modul; template
  modul mencakup BAB parent, Peta Submenu, serta pola BAB per submenu.
- Metadata YAML jenis dokumen, target, rute per role, dan daftar submenu untuk
  katalog, deteksi duplikasi, serta kelanjutan lintas-sesi yang deterministik.
- Pemilihan BAB lalu sub-bab untuk melanjutkan atau merevisi dokumen yang sudah
  ada.
- Dukungan `/fsd-convert` untuk memilih satu FSD Single Menu/Parent Menu/Modul
  dan nama `.docx` unik berdasarkan jenis serta target.
- Intent prompt ringkas `single`, `module`, `resume`, dan `open` (serta alias
  Indonesia) untuk mempercepat pembuatan, kelanjutan, dan pemilihan dokumen.
- Launcher adaptif/resume-first, discovery kandidat sebelum pembuatan, dan
  katalog ringkas berdasarkan status/progres dokumen.

### Changed

- Pesan edge case sekarang mengarahkan tindakan berikutnya, menyatakan dampak
  artefak, dan membedakan error input yang dapat dipulihkan dari integrity/
  security blocker.
- Konversi dokumen Draf memerlukan pilihan eksplisit untuk konversi sebagai draf
  atau kembali melanjutkan FSD.

- `fsd-doc` menyimpan artefak baru dengan stem yang memuat scope, jenis, dan
  target: `fsd-{scope}--single-menu--{target}.md` atau
  `fsd-{scope}--parent-module--{target}.md`.
- `template.override.md` hanya berlaku untuk legacy scope multi-menu; tipe baru
  memiliki override opt-in per jenis.

### Compatibility

- Command `/fsd-doc <role[,role...]> "<Nama Menu>"`, FSD legacy,
  sidecar/aset legacy, dan `/fsd-convert <role[,role...]>` tetap berfungsi tanpa
  migrasi otomatis.

## [2.0.0] - 2026-08-06

### Added

- `/fsd-doc <role[,role...]> "<Nama Menu>"` sekarang menerima satu role maupun
  role-set yang dipisahkan koma dan menghasilkan **satu** FSD lintas-role.
- `/fsd-convert <role[,role...]>` mendukung selector role-set yang sama untuk
  mengonversi satu FSD lintas-role menjadi satu `.docx`.
- Canonical role scope berdasarkan urutan `modules[]`; input terbalik seperti
  `applicant,admin-ta` memilih dokumen yang sama dengan `admin-ta,applicant`.
- Keputusan discovery per menu: `Unified`, `Hybrid`, atau
  `Split chapters, single document`.
- Template FSD memuat scope role, guard per role, Peta Menu role-aware, matriks
  akses/cakupan data, screenshot per role, endpoint role-aware, dan
  traceability role-aware.
- Sidecar progres menyimpan scope role canonical dan keputusan lintas-role.
- Aset screenshot dan diagram bersifat scope-aware serta screenshot disimpan
  per role.

### Changed

- `modules[]` tetap berisi role individual; tidak ada entry sintetis untuk
  role-set seperti `admin-ta,applicant`.
- Selector role-set menggunakan document key `--`, misalnya
  `fsd-admin-ta--applicant.md`; single-role tetap memakai nama legacy
  `fsd-admin-ta.md`.
- Link gambar pada FSD harus dihitung relatif dari `output.documents_dir`,
  bukan mengasumsikan folder `./images`.
- `build-docx.ps1` sekarang mengenali awalan `fsd-` saat menentukan nama output
  fallback dan menerjemahkan `--` menjadi `-Dan-`.

### Compatibility

- Config, FSD, sidecar, aset, dan nama DOCX single-role yang sudah ada tetap
  kompatibel dan tidak dimigrasikan otomatis.
- FSD single-role lama tidak pernah digabung otomatis menjadi FSD lintas-role;
  lakukan migrasi konten secara eksplisit agar source traceability tidak rusak.
- Menambah/mengurangi role dari suatu role-set menghasilkan scope/dokumen baru
  kecuali migrasi eksplisit dilakukan.
