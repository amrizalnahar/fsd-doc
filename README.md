# doc-fsd

Skill **standalone** untuk membuat **Functional Specification Document (FSD)**
langsung dari sebuah codebase — satu dokumen per modul, satu BAB per menu — lalu
mengonversinya ke `.docx` ber-brand untuk klien/UAT.

Berdiri sendiri: **tidak** butuh skill `tca-*`. Satu dependensi opsional
(`agent-browser`) untuk screenshot.

> **Repo:** `git@git.tonjoo.com:amrizal.nahar/doc-fsd.git` — root repo ini **adalah**
> paket skill. Lihat [Instalasi](#instalasi-sekali-per-laptop).

---

## Model 2 lapis (baca ini dulu)

| Lapis | Isi | Dipasang / dibuat | Berpindah antar proyek? |
|---|---|---|---|
| **Engine** (skill ini) | `SKILL.md`, `template/`, `docx-kit/` | sekali per laptop/tim | Ya — lewat skill |
| **Proyek** | `doc-fsd.config.yml` + dokumen + gambar | di dalam repo tiap klien | Tidak — tinggal di repo |

Aturan: **jangan pernah menyalin `template/` atau `docx-kit/` ke repo proyek.**
Engine datang ke proyek lewat skill; proyek hanya menyimpan config + hasil.

---

## Isi paket (= root repo)

```
doc-fsd/                          # root repo = folder skill (~/.claude/skills/doc-fsd)
├── SKILL.md                      # instruksi agent (engine)
├── README.md                     # dokumen ini
├── doc-fsd.config.example.yml    # skema/contoh config proyek
├── template/
│   └── fsd-master-template.md    # skeleton BAB + konvensi ID (satu sumber)
└── docx-kit/
    ├── reference.docx            # template gaya Word ber-brand (default netral)
    ├── build-docx.ps1            # konversi .md → .docx
    └── make-reference-docx.py    # regenerate reference.docx dari brand.* config
```

---

## Instalasi (sekali per laptop)

Repo ini **adalah** paket skill (root repo = `SKILL.md`, `template/`, `docx-kit/`).
Instalasi = menempatkan isi repo ini di direktori skill user Claude Code:

| OS | Direktori skill |
|---|---|
| macOS / Linux | `~/.claude/skills/doc-fsd` |
| Windows | `%USERPROFILE%\.claude\skills\doc-fsd` |

### 1. Pasang skill

**A. Clone langsung ke folder skill — REKOMENDASI (mudah di-update).**

```bash
# macOS / Linux — SSH (butuh SSH key terdaftar di git.tonjoo.com)
git clone git@git.tonjoo.com:amrizal.nahar/doc-fsd.git ~/.claude/skills/doc-fsd

# atau HTTPS (tanpa SSH key)
git clone https://git.tonjoo.com/amrizal.nahar/doc-fsd.git ~/.claude/skills/doc-fsd
```

```powershell
# Windows PowerShell
git clone git@git.tonjoo.com:amrizal.nahar/doc-fsd.git "$env:USERPROFILE\.claude\skills\doc-fsd"
```

Update kapan pun:

```bash
cd ~/.claude/skills/doc-fsd && git pull      # Windows: cd "$env:USERPROFILE\.claude\skills\doc-fsd"; git pull
```

**B. Clone ke workspace dev + symlink** (kalau ingin repo tersimpan di folder proyekmu):

```bash
# macOS / Linux
git clone git@git.tonjoo.com:amrizal.nahar/doc-fsd.git ~/dev/doc-fsd
ln -s ~/dev/doc-fsd ~/.claude/skills/doc-fsd
```

```powershell
# Windows (PowerShell dengan Developer Mode / admin)
git clone git@git.tonjoo.com:amrizal.nahar/doc-fsd.git C:\dev\doc-fsd
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.claude\skills\doc-fsd" -Target "C:\dev\doc-fsd"
```

**C. Tanpa git (copy manual).** Unduh arsip dari
`https://git.tonjoo.com/amrizal.nahar/doc-fsd` → ekstrak isinya ke
`~/.claude/skills/doc-fsd` (pastikan `SKILL.md` tepat di dalam folder itu, bukan
ter-nesting satu tingkat).

### 2. Verifikasi

- Pastikan file ada di: `~/.claude/skills/doc-fsd/SKILL.md`.
- Buka (atau restart) Claude Code → ketik `/doc-fsd` → perintah muncul.

### 3. Pasang prasyarat sistem

Skill hanya orkestrator; alat berat dipasang terpisah. Yang hilang tidak bikin
gagal total — langkah terkait dilewati dengan catatan.

| Prasyarat | Untuk | Wajib? | Install (Windows) | Install (macOS/Linux) |
|---|---|---|---|---|
| **Pandoc** | konversi `.md` → `.docx` | mode `build` | `winget install --id JohnMacFarlane.Pandoc` | `brew install pandoc` / `apt install pandoc` |
| **mermaid-cli** (`mmdc`) | render diagram/ERD `.mmd` → `.png` | diagram | `npm i -g @mermaid-js/mermaid-cli` | `npm i -g @mermaid-js/mermaid-cli` |
| **python-docx + PyYAML** | regenerate `reference.docx` (ganti brand) | opsional | `pip install python-docx pyyaml` | `pip install python-docx pyyaml` |
| **agent-browser** (skill) | screenshot dari app live | screenshot | pasang skill `agent-browser` | pasang skill `agent-browser` |

> Catatan: **SSH** memerlukan public key kamu terdaftar di Profil → SSH Keys pada
> git.tonjoo.com. Kalau belum, pakai URL **HTTPS**.

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
