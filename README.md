# doc-fsd

Paket **tiga skill** untuk membuat **Functional Specification Document (FSD)**
langsung dari sebuah codebase — satu dokumen per modul, satu BAB per menu — lalu
mengonversinya ke `.docx` ber-brand untuk klien/UAT.

| Skill | Command | Fungsi |
|---|---|---|
| `fsd-init` | `/fsd-init` | Bootstrap `doc-fsd.config.yml` + folder output (wawancara gap saja). |
| `fsd-doc` | `/fsd-doc <modul> "<Nama Menu>"` | Tulis/lanjutkan FSD satu modul: tambah BAB menu baru. Mode utama. |
| `fsd-convert` | `/fsd-convert <modul>` | Konversi `.md` modul → `.docx` ber-brand (salinan klien). |

Berdiri sendiri: **tidak** butuh skill `tca-*`. Satu dependensi opsional
(`agent-browser`, pasang dengan `npx skills add vercel-labs/agent-browser`) untuk
screenshot pada `fsd-doc`.

> **Repo:** `git@git.tonjoo.com:amrizal.nahar/doc-fsd.git` — root repo ini
> **adalah** paket skill. Lihat [Instalasi](#instalasi-sekali-per-laptop).

---

## Model 2 lapis (baca ini dulu)

| Lapis | Isi | Dipasang / dibuat | Berpindah antar proyek? |
|---|---|---|---|
| **Engine** (paket ini) | 3 skill di `skills/*` (masing-masing membawa asetnya) | sekali per laptop/tim | Ya — lewat skill |
| **Proyek** | `doc-fsd.config.yml` + dokumen + gambar (semua di `docs/tasks/fsd/`) | di dalam repo tiap klien | Tidak — tinggal di repo |

Aturan: **jangan pernah menyalin isi `skills/*` ke repo proyek.** Engine datang
ke proyek lewat skill; proyek hanya menyimpan config + hasil.

---

## Isi paket (= root repo)

Tiap skill **self-contained** — membawa aset yang hanya ia butuhkan, sehingga
bisa dipasang independen.

```
doc-fsd/                              # root repo = paket 3 skill
├── README.md                        # dokumen ini
├── install.sh                       # installer (macOS/Linux/Git Bash)
├── install.ps1                      # installer (Windows PowerShell)
└── skills/
    ├── fsd-init/
    │   ├── SKILL.md                 # instruksi bootstrap config
    │   └── doc-fsd.config.example.yml   # skema/contoh config proyek
    ├── fsd-doc/
    │   ├── SKILL.md                 # instruksi generator (mode utama)
    │   └── template/
    │       └── fsd-master-template.md   # skeleton BAB + konvensi ID
    └── fsd-convert/
        ├── SKILL.md                 # instruksi konversi .docx
        └── docx-kit/
            ├── reference.docx       # template gaya Word ber-brand (default netral)
            ├── build-docx.ps1       # konversi .md → .docx
            ├── make-reference-docx.py   # regenerate reference.docx dari brand.*
            └── README.md            # panduan docx-kit
```

---

## Instalasi (sekali per laptop)

Skill Claude Code ditemukan sebagai folder ber-`SKILL.md` di direktori skill
user. Karena paket ini punya tiga skill, pasang **ketiganya**:

| OS | Direktori skill |
|---|---|
| macOS / Linux | `~/.claude/skills/<nama-skill>` |
| Windows | `%USERPROFILE%\.claude\skills\<nama-skill>` |

### 1. Clone repo (sekali)

```bash
# macOS / Linux
git clone git@git.tonjoo.com:amrizal.nahar/doc-fsd.git ~/dev/doc-fsd
cd ~/dev/doc-fsd
```

```powershell
# Windows PowerShell
git clone git@git.tonjoo.com:amrizal.nahar/doc-fsd.git "$env:USERPROFILE\dev\doc-fsd"
cd "$env:USERPROFILE\dev\doc-fsd"
```

### 2. Jalankan installer

Installer menaruh ketiga folder skill ke direktori skill Claude Code (default
via symlink agar `git pull` langsung terpakai; otomatis fallback **copy** bila
symlink tak tersedia).

```bash
./install.sh                # macOS / Linux / Git Bash
./install.sh --copy         # paksa salin (tanpa symlink)
./install.sh --uninstall    # lepas ketiga skill
```

```powershell
./install.ps1               # Windows PowerShell (native)
./install.ps1 -Copy         # paksa salin
./install.ps1 -Uninstall    # lepas ketiga skill
```

> `install.sh` sudah ber-bit executable di repo. Bila tetap muncul `permission
> denied` (mis. hasil unduh ZIP), jalankan `bash install.sh` atau `chmod +x
> install.sh` sekali. Di Windows jalankan lewat **Git Bash**.

Update kapan pun: `git pull` di folder repo, lalu jalankan installer lagi
(symlink otomatis ikut versi baru; mode copy menyalin ulang isi terbaru).

### 3. Verifikasi

- File ada di: `~/.claude/skills/fsd-init/SKILL.md`, `.../fsd-doc/SKILL.md`,
  `.../fsd-convert/SKILL.md`.
- Buka (atau restart) Claude Code → ketik `/fsd-` → `/fsd-init`, `/fsd-doc`,
  `/fsd-convert` muncul.

> **Kenapa perlu installer?** Claude Code hanya mengenali skill pada kedalaman
> tetap `~/.claude/skills/<nama>/SKILL.md`, sedangkan `git clone` menaruhnya satu
> tingkat lebih dalam (`repo/skills/<nama>/`). Installer menautkan/menyalin tiap
> skill ke tempat yang benar. Nama command diambil dari **nama folder** skill
> (`fsd-init` → `/fsd-init`).

### Prasyarat sistem

Skill hanya orkestrator; alat berat dipasang terpisah. Yang hilang tidak bikin
gagal total — langkah terkait dilewati dengan catatan.

| Prasyarat | Untuk skill | Wajib? | Install (Windows) | Install (macOS/Linux) |
|---|---|---|---|---|
| **Pandoc** | `fsd-convert` | ya (konversi) | `winget install --id JohnMacFarlane.Pandoc` | `brew install pandoc` / `apt install pandoc` |
| **mermaid-cli** (`mmdc`) | `fsd-doc` (diagram/ERD) | opsional | `npm i -g @mermaid-js/mermaid-cli` | `npm i -g @mermaid-js/mermaid-cli` |
| **python-docx + PyYAML** | `fsd-convert` (regenerate `reference.docx`) | opsional | `pip install python-docx pyyaml` | `pip install python-docx pyyaml` |
| **agent-browser** (skill) | `fsd-doc` (screenshot) | opsional | `npx skills add vercel-labs/agent-browser` | `npx skills add vercel-labs/agent-browser` |

> Catatan: **SSH** memerlukan public key kamu terdaftar di Profil → SSH Keys pada
> git.tonjoo.com. Kalau belum, pakai URL **HTTPS**
> (`https://git.tonjoo.com/amrizal.nahar/doc-fsd.git`).

---

## Pemakaian di sebuah proyek

### 1. Inisialisasi (sekali per repo)

```
/fsd-init
```

Skill mendeteksi framework/path dari repo, menanyakan sisanya (nama, klien, URL
app, daftar modul + guard + kredensial), lalu menulis config ke
`docs/tasks/fsd/doc-fsd.config.yml` (**bukan** root repo, agar tidak mengotori
repo utama) dan membuat folder output di bawah `docs/tasks/fsd/`.

### 2. Tulis / lanjutkan FSD

```
/fsd-doc admin-ta "Manage Vacancy"
/fsd-doc admin-ta "Job Applicant"     # menu berikutnya → BAB baru
```

> **Konvensi:** `<modul>` umumnya = satu **role/portal pengguna** (mis. `admin-ta`,
> `applicant`, `public`), masing-masing dijaga guard/role sendiri di `modules[]`.
> Jadi `<modul>` boleh dibaca sebagai **nama role** — satu dokumen FSD mencakup
> seluruh menu yang diakses role tersebut.

- File baru → isi BAB I lalu BAB II.
- File ada → menu ditambahkan sebagai BAB baru; BAB sebelumnya tidak diubah;
  Daftar Isi + Peta Menu (1.4) diperbarui.

### 3. Konversi ke .docx (salinan klien)

```
/fsd-convert admin-ta
```

Output ber-brand sesuai `brand.*` config, pola nama `FSD-Modul-{Modul}`.

---

## Menyesuaikan per proyek

- **Brand `.docx`** — ubah `brand.*` di `doc-fsd.config.yml` lalu regenerate
  `reference.docx` (`skills/fsd-convert/docx-kit/make-reference-docx.py`). Lihat
  `docx-kit/README.md` untuk detail.
- **Struktur BAB berbeda** — buat `docs/tasks/fsd/template.override.md` di repo
  proyek; `fsd-doc` memakainya bila ada. Jangan menyalin seluruh template default.

---

## Yang TIDAK dilakukan paket ini

- Tidak mengubah kode sumber proyek (read-only terhadap codebase).
- Tidak memanggil `tca-init`/`tca-doc` atau skill lain, kecuali `agent-browser`
  (opsional) untuk screenshot.
- Tidak menyimpan nilai proyek di engine — semua dari `doc-fsd.config.yml`.
