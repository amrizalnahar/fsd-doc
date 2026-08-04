# doc-fsd

Skill **standalone** untuk membuat **Functional Specification Document (FSD)**
langsung dari sebuah codebase — satu dokumen per modul, satu BAB per menu — lalu
mengonversinya ke `.docx` ber-brand untuk klien/UAT.

Berdiri sendiri: **tidak** butuh skill `tca-*`. Satu dependensi opsional
(`agent-browser`) untuk screenshot.

---

## Model 2 lapis (baca ini dulu)

| Lapis | Isi | Dipasang / dibuat | Berpindah antar proyek? |
|---|---|---|---|
| **Engine** (skill ini) | `SKILL.md`, `template/`, `docx-kit/` | sekali per laptop/tim | Ya — lewat skill |
| **Proyek** | `doc-fsd.config.yml` + dokumen + gambar | di dalam repo tiap klien | Tidak — tinggal di repo |

Aturan: **jangan pernah menyalin `template/` atau `docx-kit/` ke repo proyek.**
Engine datang ke proyek lewat skill; proyek hanya menyimpan config + hasil.

---

## Isi paket

```
doc-fsd/
├── SKILL.md                      # instruksi agent (engine)
├── README.md                     # dokumen ini
├── doc-fsd.config.example.yml    # skema/contoh config proyek
├── template/
│   └── fsd-master-template.md    # skeleton BAB + konvensi ID (satu sumber)
└── docx-kit/
    ├── reference.docx            # template gaya Word ber-brand
    ├── build-docx.ps1            # konversi .md → .docx
    └── make-reference-docx.py    # regenerate reference.docx (ubah brand/font)
```

---

## Instalasi (sekali per laptop)

### 1. Pasang skill

Pilih salah satu cara:

**A. Copy manual (paling cepat).** Salin folder `doc-fsd/` ke direktori skill user:

```bash
# Windows
cp -r doc-fsd "$USERPROFILE/.claude/skills/doc-fsd"
# macOS / Linux
cp -r doc-fsd ~/.claude/skills/doc-fsd
```

**B. Git repo (untuk tim).** doc-fsd punya repo sendiri; clone langsung ke folder skill:

```bash
git clone git@github.com:<org>/doc-fsd.git ~/.claude/skills/doc-fsd
# update: cd ~/.claude/skills/doc-fsd && git pull
```

**C. Marketplace/plugin (versi-an, paling rapi).** Publish sebagai plugin lalu:

```
/plugin marketplace add <org>/<marketplace>
/plugin install doc-fsd@<org>
```

Setelah terpasang, buka Claude Code → perintah `/doc-fsd` akan tersedia.

### 2. Pasang prasyarat sistem

Skill hanya orkestrator; alat berat dipasang terpisah. Yang hilang tidak bikin
gagal total — langkah terkait akan dilewati dengan catatan.

| Prasyarat | Untuk | Wajib? | Install |
|---|---|---|---|
| **Pandoc** | konversi `.md` → `.docx` | mode `build` | `winget install --id JohnMacFarlane.Pandoc` |
| **mermaid-cli** (`mmdc`) | render diagram/ERD `.mmd` → `.png` | diagram | `npm i -g @mermaid-js/mermaid-cli` |
| **agent-browser** (skill) | screenshot dari app live | screenshot | sudah tersedia di banyak proyek Tonjoo |
| **python-docx** | regenerate `reference.docx` (ganti brand) | opsional | `pip install python-docx` |

---

## Pemakaian di sebuah proyek

### 1. Inisialisasi (sekali per repo)

```
/doc-fsd init
```

Skill mendeteksi framework/path dari repo, menanyakan sisanya (nama, klien, URL
app, daftar modul + guard + kredensial), lalu menulis `doc-fsd.config.yml` dan
membuat folder output. Atau salin `doc-fsd.config.example.yml` secara manual.

### 2. Tulis / lanjutkan FSD

```
/doc-fsd doc admin-ta "Manage Vacancy"
/doc-fsd doc admin-ta "Job Applicant"     # menu berikutnya → BAB baru
```

- File baru → isi BAB I lalu BAB II.
- File ada → menu ditambahkan sebagai BAB baru; BAB sebelumnya tidak diubah;
  Daftar Isi + Peta Menu (1.4) diperbarui.

### 3. Konversi ke .docx (salinan klien)

```
/doc-fsd build admin-ta
```

Output ber-brand sesuai `brand.*` config, pola nama `FSD-Modul-{Modul}`.

---

## Menyesuaikan per proyek

- **Brand `.docx`** — ubah `brand.*` di config lalu regenerate `reference.docx`
  (`docx-kit/make-reference-docx.py`). Lihat `docx-kit` untuk detail.
- **Struktur BAB berbeda** — buat `docs/tasks/fsd/template.override.md` di repo
  proyek; skill memakainya bila ada. Jangan menyalin seluruh template default.

---

## Yang TIDAK dilakukan skill ini

- Tidak mengubah kode sumber proyek (read-only terhadap codebase).
- Tidak memanggil `tca-init`/`tca-doc` atau skill lain, kecuali `agent-browser`
  (opsional) untuk screenshot.
- Tidak menyimpan nilai proyek di engine — semua dari `doc-fsd.config.yml`.
