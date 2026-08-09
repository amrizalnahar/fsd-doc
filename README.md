# doc-fsd

> **Versi 2.0.0** — mendukung satu FSD lintas-role dari selector role yang
> dipisahkan koma. Lihat [CHANGELOG.md](CHANGELOG.md).

Paket **tiga skill** untuk membuat **Functional Specification Document (FSD)**
langsung dari sebuah codebase — satu dokumen per **scope role/portal**, satu BAB
per menu atau varian menu — lalu mengonversinya ke `.docx` ber-brand untuk
klien/UAT.

| Skill | Command | Fungsi |
|---|---|---|
| `fsd-init` | `/fsd-init` | Bootstrap `doc-fsd.config.yml` + folder output (wawancara gap saja). |
| `fsd-doc` | `/fsd-doc <role[,role...]>` | Launcher untuk membuat/membuka FSD Single Menu atau Parent Menu/Modul; command kompatibel `/fsd-doc <role[,role...]> "<Nama Menu>"` tetap mengelola FSD scope multi-menu legacy. |
| `fsd-convert` | `/fsd-convert <role[,role...]> ["<Nama FSD>"]` | Konversi satu FSD terpilih menjadi `.docx` ber-brand (salinan klien). |

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
    │   ├── doc-fsd.config.example.yml   # skema/contoh config proyek
    │   └── validate-config.py       # preflight validator skema config (dipakai fsd-init/-doc/-convert)
    ├── fsd-doc/
    │   ├── SKILL.md                 # instruksi generator (mode utama)
    │   └── template/
    │       ├── fsd-master-template.md        # legacy scope multi-menu
    │       ├── fsd-single-menu-template.md   # satu menu
    │       └── fsd-parent-module-template.md # parent/modul + submenu
    └── fsd-convert/
        ├── SKILL.md                 # instruksi konversi .docx
        └── docx-kit/
            ├── reference.docx       # template gaya Word ber-brand (default netral)
            ├── build-docx.ps1       # konversi .md → .docx
            ├── make-reference-docx.py   # regenerate reference.docx dari brand.*
            ├── insert-logo.py       # sisipkan brand.logo ke sampul (post-process)
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
| **python-docx + PyYAML** | `fsd-convert` (regenerate `reference.docx`, sisip logo) | opsional | `pip install python-docx pyyaml` | `pip install python-docx pyyaml` |
| **PyYAML** | `fsd-init` (`validate-config.py`, dipakai juga oleh `fsd-doc`/`fsd-convert`) | opsional (tanpa ini validasi config dilewati dgn catatan) | `pip install pyyaml` | `pip install pyyaml` |
| **agent-browser** (skill) | `fsd-doc` (screenshot) | opsional | `npx skills add vercel-labs/agent-browser -a claude-code -y` | `npx skills add vercel-labs/agent-browser -a claude-code -y` |

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
app, daftar role/portal + guard + lokasi kredensial), lalu menulis config ke
`docs/tasks/fsd/doc-fsd.config.yml` (**bukan** root repo, agar tidak mengotori
repo utama) dan membuat folder output di bawah `docs/tasks/fsd/`.

### 2. Tulis / lanjutkan FSD

```
# Launcher adaptif: rekomendasi lanjutkan Draf atau katalog dokumen
/fsd-doc admin-ta
/fsd-doc admin-ta,applicant

# Langsung membuat satu menu atau satu modul
/fsd-doc admin-ta single "Manage Vacancy"
/fsd-doc admin-ta module "Master Data"
# alias Indonesia: menu, modul, lanjut, buka
/fsd-doc admin-ta lanjut
/fsd-doc admin-ta buka

# Mode kompatibel/legacy: satu FSD scope-role dengan banyak BAB menu
/fsd-doc admin-ta "Dashboard"
/fsd-doc admin-ta "Manage Vacancy"       # menu berikutnya → BAB baru

# Scope lintas-role tetap didukung dan urutan selector dinormalisasi
/fsd-doc admin-ta,applicant "Dashboard"
/fsd-doc applicant,admin-ta "Notification"
```

> **Konvensi:** `modules[]` memuat satu **role/portal pengguna** per entry (mis.
> `admin-ta`, `applicant`, `public`), masing-masing dengan guard dan kredensial
> sendiri. Selector satu role menghasilkan satu FSD fokus role tersebut; selector
> role yang dipisahkan koma menghasilkan **satu FSD lintas-role**. Role diurutkan
> **leksikografis berdasarkan slug** (bukan urutan `modules[]` config, yang bisa
> berubah bila proyek mengedit ulang urutan entry, dan bukan urutan prompt).

#### Launcher `/fsd-doc <role[,role...]>`

Launcher membaca katalog dan sidecar dulu, lalu beradaptasi:

- Jika hanya ada satu pekerjaan **Draf**, launcher merekomendasikan titik-lanjut
  tersebut sebagai pilihan pertama.
- Jika ada beberapa Draf, launcher menampilkan daftar pekerjaan yang perlu
  dilanjutkan; dokumen Selesai tetap tersedia melalui **Lihat semua dokumen**.
- Jika katalog kosong, launcher langsung menawarkan pembuatan Single Menu,
  Parent Menu/Modul, atau legacy multi-menu.

Katalog menampilkan nama target, jenis, role, status, dan progres ringkas — bukan
nama file teknis. Contoh:

```text
[Perlu dilanjutkan] Parent Menu/Modul · Master Data
3 dari 5 submenu · Position → Aturan Bisnis (Draf)
Role: Admin TA
```

Saat membuat **Single Menu**, skill terlebih dahulu menemukan kandidat menu/rute,
lalu user mengonfirmasi kandidat yang benar. Jika menu sudah memiliki dokumen,
pilihan default adalah melanjutkan dokumen itu, bukan membuat duplikat.

Saat membuat **Parent Menu/Modul**, skill terlebih dahulu memverifikasi parent
(sebagai halaman atau ekspander navigasi), kemudian menawarkan submenu yang benar-
benar ditemukan sebagai daftar pilihan. Parent tanpa rute tetap dapat didokumentasi
bila memang ekspander yang menaungi submenu.

Saat merevisi, titik-lanjut sidecar menjadi pilihan pertama. Jika memilih area lain,
pilih BAB dahulu lalu sub-bab; sebelum perubahan, skill menyebut batas perubahan
agar BAB lain tetap beku.

| Jenis | Dokumen | Sidecar |
|---|---|---|
| Legacy scope multi-menu | `fsd-{scope-key}.md` | `fsd-{scope-key}.progress.md` |
| Single Menu | `fsd-{scope-key}--single-menu--{target-key}.md` | stem yang sama + `.progress.md` |
| Parent Menu/Modul | `fsd-{scope-key}--parent-module--{target-key}.md` | stem yang sama + `.progress.md` |

`target-key` dibentuk dari hasil discovery, bukan sekadar judul prompt. Metadata
YAML menyimpan jenis, scope canonical, target, rute per role, serta `child_menus`
untuk modul. Saat launcher dipanggil lagi, metadata dan rute ini membuat skill
dapat menemukan dokumen yang sudah ada tanpa membuat duplikat. Nama file dan
metadata adalah mekanisme internal: user cukup memilih kartu dokumen yang
menampilkan nama, jenis, role, dan progres.

- File legacy baru → isi BAB I lalu BAB II; file legacy ada → menu yang belum ada
  ditambahkan sebagai BAB baru dan BAB yang sudah ada dilanjutkan secara idempoten.
- Single Menu tidak menerima menu tambahan (kecuali BAB Split untuk varian role
  dari menu yang sama).
- Parent Menu/Modul menulis satu BAB parent lalu satu BAB mandiri per submenu.
  Penambahan submenu hanya menambah BAB submenu, Peta Submenu, metadata, dan
  sidecar; submenu lama tidak diubah tanpa pemilihan revisi eksplisit.
- Single-role mempertahankan nama file, sidecar, aset, dan output DOCX lama.
  Dokumen role-set adalah scope baru; skill **tidak menggabungkan otomatis** FSD
  single-role yang sudah ada.

#### Template override per jenis

Override legacy yang ada tetap memakai `docs/tasks/fsd/template.override.md`.
Untuk tipe baru, gunakan `template.single-menu.override.md` atau
`template.parent-module.override.md` di folder yang sama. Bila tidak ada,
engine memakai template bawaan khusus jenis tersebut; override legacy tidak
berlaku otomatis untuk dokumen baru.

#### Keputusan bentuk menu lintas-role

Sebelum menulis, `fsd-doc` memetakan route, guard, policy/query, komponen UI,
data, endpoint, aksi, dan screenshot untuk **setiap role**. Nama menu atau UI
saja tidak cukup. Hasilnya selalu salah satu berikut, tetap di satu dokumen:

| Hasil discovery | Bentuk di FSD |
|---|---|
| **Unified** | Satu BAB dengan fungsi/alur bersama dan matriks role, permission, serta cakupan data. |
| **Hybrid** | Satu BAB dengan konsep bersama, subbagian per role/kelompok, dan matriks lengkap. |
| **Split chapters, single document** | BAB terpisah per varian/role karena tujuan atau alur berbeda material, tetap pada file role-set yang sama. |

Screenshot disimpan dan diberi caption per role; permission harus dibuktikan pada
visibilitas menu, akses rute langsung, cakupan data, widget/field, aksi, dan
penegakan backend — bukan hanya tombol yang tersembunyi.

### Memahami mode multi-role (v2.0.0)

#### Apa yang dipilih oleh argumen pertama?

Argumen pertama **bukan nama file bebas** dan bukan role baru. Ia adalah selector
atas entry `modules[]` pada `doc-fsd.config.yml`:

```yaml
modules:
  - slug: admin-ta
    title: "TA Portal"
    guard: "auth:admin-ta"
    credentials: "docs/tasks/credentialRoles/admin-ta.md"
  - slug: applicant
    title: "Applicant Portal"
    guard: "auth:applicant"
    credentials: "docs/tasks/credentialRoles/applicant.md"
```

Berikut perilakunya:

| Selector | Makna | Key dokumen | File Markdown |
|---|---|---|---|
| `admin-ta` | Hanya role Admin TA | `admin-ta` | `fsd-admin-ta.md` |
| `applicant` | Hanya role Applicant | `applicant` | `fsd-applicant.md` |
| `admin-ta,applicant` | Satu scope berisi Admin TA dan Applicant | `admin-ta--applicant` | `fsd-admin-ta--applicant.md` |

Role harus ada di `modules[]`. Skill menghentikan proses **sebelum menulis file**
apabila selector memiliki role tidak dikenal, token kosong (`admin-ta,,applicant`),
atau role berulang (`admin-ta,admin-ta`). Slug role harus unik, stabil, dan tidak
boleh mengandung `--` karena karakter itu dipakai sebagai separator key dokumen.

#### Mengapa urutan selector tidak menentukan file baru?

Skill mengurutkan role **leksikografis berdasarkan slug**, bukan urutan entry di
`modules[]`. Dengan config di atas:

```text
admin-ta,applicant  → admin-ta--applicant
applicant,admin-ta  → admin-ta--applicant
```

Ini mencegah dua dokumen yang isinya sama tetapi berbeda hanya karena urutan prompt
**atau** karena `modules[]` di config diedit ulang urutannya — urutan array config
bersifat mutable dan tidak dipakai sebagai identitas. Saat melanjutkan dokumen,
gunakan role-set yang sama. Menambah atau mengurangi role adalah **scope baru**,
bukan perubahan diam-diam pada dokumen lama.

Bila `{document_key}` hasil urutan leksikografis tidak menemukan dokumen yang
ada, tetapi ada dokumen lama dengan key hasil urutan `modules[]` lama (dari versi
skill sebelum perbaikan ini) → skill **berhenti** dan meminta migrasi/rename
eksplisit, bukan diam-diam membuat dokumen scope duplikat.

#### Apa yang sebenarnya ada di satu FSD lintas-role?

Satu file lintas-role tetap memiliki satu BAB I dan beberapa BAB menu. BAB I
menjelaskan seluruh role/portal, guard, dan model akses umum. Setiap BAB menu
secara eksplisit menyatakan role yang tercakup, rute per role, serta bentuk
hasil discovery-nya.

```text
fsd-admin-ta--applicant.md
├── BAB I    Informasi umum scope Admin TA + Applicant
├── BAB II   Dashboard
│   ├── fungsi/perilaku bersama
│   ├── variasi Admin TA dan Applicant bila ada
│   ├── matriks akses dan cakupan data
│   └── screenshot serta bukti sumber per role
├── BAB III  Notification
└── ...
```

Bukan berarti dua halaman yang kebetulan bernama “Dashboard” selalu dipaksa
menjadi satu BAB. Sebelum menulis, skill mencari bukti kode per role: posisi menu,
redirect login, route, guard/middleware/policy, API/handler/query, scope data,
kondisi UI, aksi, dan pesan sistem.

| Kondisi yang terbukti | Keputusan | Hasil di dokumen tunggal |
|---|---|---|
| Tujuan bisnis, fungsi inti, dan pola alur utama sama | **Unified** | Satu BAB; perilaku bersama ditulis sekali, perbedaan ada pada matriks role. |
| Konsep bersama, tetapi data, widget, aksi, atau alur tindak lanjut berbeda cukup besar | **Hybrid** | Satu BAB; konsep bersama + subbagian per role/kelompok + matriks lengkap. |
| Yang sama hanya label menu, sedangkan tujuan/alur/domain data berbeda material | **Split chapters, single document** | BAB dipisah per varian/role, tetapi tetap di file `fsd-admin-ta--applicant.md`. |

Contoh kasus **Dashboard**:

```text
Admin TA    : melihat ringkasan lowongan/kandidat → membuka tindak lanjut rekrutmen
Applicant   : melihat ringkasan lamaran          → membuka tindak lanjut lamaran
```

Jika keduanya terbukti menjalankan pola “melihat ringkasan aktivitas lalu membuka
tindak lanjut”, hasilnya umumnya **Unified** atau **Hybrid**. Sebaliknya, jika
Dashboard Applicant sebenarnya wizard kelengkapan profil sedangkan Dashboard
Admin TA adalah analitik operasional, hasil yang jujur adalah **Split chapters,
single document**.

#### Bagaimana permission dan screenshot dibuktikan?

Setiap role masuk menggunakan `modules[].credentials` miliknya sendiri. Skill
tidak boleh menyimpulkan hak Applicant dari sesi atau screenshot Admin TA.

Perbedaan akses harus diperiksa dari enam lapisan berikut:

1. visibilitas menu pada navigasi;
2. akses URL/rute secara langsung (diizinkan, redirect, atau 403);
3. cakupan data yang dapat dibaca;
4. widget atau field yang muncul/disamarkan;
5. aksi yang dapat dilakukan; dan
6. penegakan backend melalui guard, policy, query scope, atau API.

FSD menyajikan hasilnya sebagai matriks role. Contoh bentuknya:

| Role | Menu | Rute | Cakupan Data | Widget / Aksi | Penegakan |
|---|---|---|---|---|---|
| Admin TA | Tampil | Diizinkan | Data rekrutmen organisasi | KPI lowongan, kelola lowongan | Guard + query organisasi |
| Applicant | Tampil | Diizinkan | Data milik pengguna login | Status lamaran, buka detail | Guard + ownership scope |

Screenshot dan diagram lintas-role disimpan di bawah key scope agar tidak saling
timpa, misalnya:

```text
docs/tasks/fsd/assets/screenshots/
└── admin-ta--applicant/
    └── dashboard/
        ├── admin-ta/
        │   └── dash-overview.png
        └── applicant/
            └── dash-overview.png
```

Link gambar dalam Markdown dihitung relatif dari `output.documents_dir`; jangan
menyalin pola `./images/` lama ke template override proyek.

#### Melanjutkan, memigrasikan, atau memisahkan dokumen

- Memakai selector single-role setelah pernah membuat selector multi-role tetap
  membuat/memperbarui dokumen **berbeda**; ini normal karena scope-nya berbeda.
- Skill tidak pernah menggabungkan otomatis `fsd-admin-ta.md` dan
  `fsd-applicant.md`. Penggabungan otomatis dapat mencampur ID, screenshot,
  klaim, dan source traceability yang konflik.
- Untuk berpindah dari dua FSD lama ke satu FSD lintas-role, panggil selector
  multi-role sebagai dokumen baru, lalu porting ulang hanya konten yang sudah
  diverifikasi beserta source dan assetnya.
- Bila sebuah menu ternyata Split, **jangan** membuat file baru per role. Pecah
  BAB/varian di dalam FSD role-set yang sama.

### 3. Konversi ke .docx (salinan klien)

```
# Tetap mengonversi FSD legacy canonical bila file tersebut ada
/fsd-convert admin-ta

# Selector lintas-role canonical
/fsd-convert admin-ta,applicant
/fsd-convert applicant,admin-ta

# Buka katalog atau pilih jenis + target secara eksplisit
/fsd-convert admin-ta open
/fsd-convert admin-ta single "Manage Vacancy"
/fsd-convert admin-ta module "Master Data"
# Target judul lama tetap didukung
/fsd-convert admin-ta "Master Data"
```

`fsd-convert` menerapkan validasi dan canonicalization selector yang sama dengan
`fsd-doc`. Tanpa target ia memilih `fsd-{scope_key}.md` legacy agar command
existing tetap kompatibel. Dengan target — atau bila legacy tidak ada dan katalog
memiliki satu kandidat — skill memilih satu FSD baru berdasarkan metadata YAML.
Jika kandidat lebih dari satu atau target ambigu, skill menampilkan kartu jenis,
role, progres, dan submenu sebelum meminta pilihan pengguna; ia **tidak**
menyatukan dokumen yang berbeda. Bila dokumen yang dipilih masih Draf, user
memilih konversi sebagai draf atau kembali melanjutkan FSD.

Output ber-brand sesuai `brand.*` config. Legacy memakai pola
`FSD-Modul-{Modul}`; role-set legacy menggunakan nama scope canonical, misalnya
`FSD-Modul-Admin-Ta-Dan-Applicant.docx`. Output tipe baru menambahkan jenis dan
target agar tidak menimpa, misalnya
`FSD-Modul-Admin-Ta-Parent-Modul-Master-Data.docx`.

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
