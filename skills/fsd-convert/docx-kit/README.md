# Kit Konversi FSD → .docx

Kit ini mengubah dokumen FSD Markdown (`fsd-*.md`) menjadi `.docx` yang **rapi,
elegan, dan profesional** dengan warna brand proyek — lengkap dengan **halaman
sampul**, **Daftar Isi otomatis**, **nomor halaman**, dan **satu BAB per
halaman**.

Prinsip kunci: Markdown adalah sumber **isi**; tampilan `.docx` ditentukan oleh
**`reference.docx`** (template gaya Word). Isi ditulis sekali, gaya diatur sekali,
semua FSD tampil konsisten. Warna/font/label `reference.docx` diambil dari
`brand.*` + `project.*` pada **doc-fsd.config.yml** proyek.

Biasanya kamu tidak memanggil kit ini langsung — jalankan
`/fsd-convert <role[,role...]>`. Satu role memilih satu FSD; role dipisahkan
koma memilih satu FSD lintas-role canonical. Bagian di bawah untuk pemakaian
manual / penyesuaian.

---

## Isi folder

| Berkas | Fungsi |
|---|---|
| `reference.docx` | Template gaya Word (font, heading, tabel, sampul, header/footer). Dipakai Pandoc. |
| `make-reference-docx.py` | Pembangun `reference.docx`; membaca brand dari `doc-fsd.config.yml`. |
| `build-docx.ps1` | Satu perintah konversi `.md` → `.docx`. |
| `harden-table-headers.py` | Post-process: bake teks putih + latar brand header tabel sebagai *direct formatting* agar tetap benar di **Google Docs** (dipanggil otomatis oleh `build-docx.ps1`). |
| `fit-images.py` | Post-process: batasi *ukuran tampilan* gambar (bukan resolusi PNG) agar proporsional (tak 1 halaman/gambar) + pusatkan; dipanggil otomatis oleh `build-docx.ps1`. |
| `insert-logo.py` | Post-process: sisipkan `brand.logo` (bila diatur di config) ke sampul — Pandoc mengabaikan body `reference.docx` sehingga logo tak bisa ditempel di sana; dipanggil otomatis oleh `build-docx.ps1`. |
| `README.md` | Dokumen ini. |

---

## Prasyarat

1. **Pandoc** — mesin konversi
   ```powershell
   winget install --id JohnMacFarlane.Pandoc
   ```
2. **python-docx** + **PyYAML** — hanya bila me-*regenerate* `reference.docx`
   ```powershell
   pip install python-docx pyyaml
   ```
   (`reference.docx` sudah tersedia dengan brand default netral; regenerate hanya
   bila brand proyek berbeda.)

---

## Cara pakai (manual)

### 1. Siapkan salinan untuk dikonversi

Sebelum konversi (terutama salinan klien), siapkan **salinan**
(biar master `.md` tetap utuh untuk dibaca di GitHub):

1. **Isi metadata sampul** — blok YAML `---` di paling atas file (judul, modul,
   versi, tanggal, penyusun, klien). Inilah **halaman sampul**.
2. **Hapus blok "Daftar Isi" manual** — Word membuatnya otomatis (`--toc`);
   membiarkannya = Daftar Isi ganda.
3. Pastikan semua diagram sudah PNG (Pandoc meng-embed PNG, bukan `.mmd`).

`build-docx.ps1` sendiri **otomatis**:
- memangkas setiap blok `<!-- INTERNAL:START --> … <!-- INTERNAL:END -->`
  (mis. Matriks Keterlacakan) dari salinan sebelum dikonversi — artefak
  internal tim tidak pernah sampai ke `.docx` klien; skrip berhenti dengan
  error bila menemukan penanda tak berpasangan;
- memvalidasi setiap referensi gambar lokal (`![...](path)`) sebelum memanggil
  Pandoc dan **gagal (fail-fast)** dengan daftar path yang hilang, bukan diam-
  diam mengganti gambar dengan teks alt.

Jadi langkah 1–3 di atas tetap disarankan untuk kerapian salinan, tetapi
pemangkasan INTERNAL dan validasi gambar tidak lagi bergantung pada langkah
manual ini.

### 2. Konversi

```powershell
# role tunggal
./build-docx.ps1 <path>/fsd-admin-ta.md -Out <path>/FSD-Modul-Admin-Ta.docx

# scope lintas-role; /fsd-convert sudah meresolve urutan role canonical
./build-docx.ps1 <path>/fsd-admin-ta--applicant.md -Out <path>/FSD-Modul-Admin-Ta-Dan-Applicant.docx
```

Tanpa `-Out`, skrip menurunkan nama dari awalan `fsd-` dan menerjemahkan `--`
menjadi `-Dan-`; tetap gunakan `-Out` eksplisit untuk output klien yang stabil.
Buka di Word; bila Daftar Isi belum terisi, klik kanan → **Update Field**.

Opsi:
```powershell
./build-docx.ps1 <input.md> -Out ./FSD-Khusus.docx        # nama output manual
./build-docx.ps1 <input.md> -TocDepth 3                    # sertakan sub-sub-bab
./build-docx.ps1 <input.md> -Reference ./client-ref.docx   # template kustom (docx.reference)
```

Tanpa `-Reference`, skrip memakai `reference.docx` bawaan di folder ini.

---

## Yang dihasilkan `reference.docx`

- **Halaman sampul** dari metadata: judul, subjudul, penyusun, tanggal — terpusat.
- **Daftar Isi** otomatis (mulai halaman baru).
- **Heading berwarna brand** (font judul), isi font body 11pt, spasi 1.15.
- **Setiap BAB mulai di halaman baru** (page-break otomatis pada Heading 1).
- **Perataan**: paragraf isi rata kanan-kiri (justify); teks dalam sel tabel rata
  kiri; gambar & blok tabel rata tengah (paragraf gambar juga dipusatkan ulang
  oleh `fit-images.py` sebagai pengaman).
- **Ukuran gambar**: diagram Mermaid dirender skala tinggi (`mmdc -s 3`) agar tajam,
  tetapi Pandoc meng-embed pada ukuran native sehingga satu gambar bisa memenuhi
  satu halaman. `fit-images.py` membatasi *ukuran tampilan* (lebar <= area cetak,
  tinggi <= setengah halaman; ubah lewat `--max-height-frac`/`--max-height-in`)
  tanpa menyentuh piksel PNG — jadi proporsional namun tetap tajam saat diperlebar.
- **Tabel**: grid tipis, baris header berlatar warna brand + teks putih. Warna
  header dibaking sebagai *direct formatting* (oleh `harden-table-headers.py`)
  supaya bertahan saat dokumen diunggah ke **Google Docs** — yang mengabaikan
  *conditional formatting* gaya tabel sehingga teks putih akan jadi hitam tanpa ini.
- **Header/footer**: label dokumen (dari `project.*`) + "Halaman X dari Y".
- **Logo sampul** (opsional): `brand.logo` disisipkan oleh `insert-logo.py`
  (dipanggil otomatis oleh `build-docx.ps1`, lihat bagian berikutnya).

---

## Menyesuaikan tampilan (warna, font, logo)

Ubah **`brand.*`** di `doc-fsd.config.yml` proyek, lalu regenerate:

```powershell
py make-reference-docx.py            # cari config otomatis (naik dari cwd)
# atau tunjuk eksplisit:
$env:DOC_FSD_CONFIG="D:\path\doc-fsd.config.yml"; py make-reference-docx.py
```

Yang dibaca dari config: `brand.color_primary` (heading & tabel header),
`brand.color_primary_dark` (judul sampul), `brand.color_accent` (opsional),
`brand.font_heading`, `brand.font_body`, serta `project.name`/`project.client`
untuk label header. Font harus terpasang di komputer pembuka dokumen.

> Pandoc hanya mengambil **definisi gaya + margin + header/footer** dari
> `reference.docx`; isi body-nya diabaikan. Karena itu `brand.logo` **tidak**
> diproses di sini — lihat `insert-logo.py` di bawah.

`brand.logo` (path relatif terhadap root repo proyek, mis. `assets/logo.png`)
disisipkan ke sampul oleh `insert-logo.py`, dipanggil otomatis sesudah Pandoc
oleh `build-docx.ps1`:

```powershell
./build-docx.ps1 <input.md> -Out <out.docx>       # logo otomatis bila brand.logo diisi
py insert-logo.py <out.docx>                       # atau jalankan manual
py insert-logo.py <out.docx> --logo ./logo.png     # override path eksplisit
```

Kosong = tanpa logo, bukan error. Diisi tapi file tidak ditemukan = seluruh
build gagal (exit 1) dengan pesan path yang salah — bukan sampul klien yang
diam-diam tanpa logo. Butuh `pip install python-docx pyyaml`.

---

## Kenapa tidak "cover page di Markdown saja"?

Markdown tak punya kendali atas font, warna, gaya tabel, header/footer, atau
nomor halaman Word. Sampul dan tampilan profesional **hanya bisa** diwujudkan di
lapisan konversi (`reference.docx`) — bukan di body `.md`. Pendekatan ini menjaga
`.md` tetap bersih & mudah dibaca, sementara polesan tampilan terpusat di satu
template yang dipakai ulang semua FSD.
