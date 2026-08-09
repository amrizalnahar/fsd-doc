# Changelog

Semua perubahan penting doc-fsd dicatat dalam dokumen ini.

Format mengacu pada [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
dan project memakai [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
