# Kit Konversi FSD → .docx

Kit ini mengubah dokumen FSD Markdown (`fsd-*.md`) menjadi `.docx` yang **rapi,
elegan, dan profesional** dengan warna brand proyek — lengkap dengan **halaman
sampul**, **Daftar Isi otomatis**, **nomor halaman**, dan **satu BAB per
halaman**.

Prinsip kunci: Markdown adalah sumber **isi**; tampilan `.docx` ditentukan oleh
**`reference.docx`** (template gaya Word). Isi ditulis sekali, gaya diatur sekali,
semua FSD tampil konsisten. Warna/font/label `reference.docx` diambil dari
`brand.*` + `project.*` pada **doc-fsd.config.yml** proyek.

Biasanya kamu tidak memanggil kit ini langsung — jalankan `/doc-fsd build <modul>`.
Bagian di bawah untuk pemakaian manual / penyesuaian.

---

## Isi folder

| Berkas | Fungsi |
|---|---|
| `reference.docx` | Template gaya Word (font, heading, tabel, sampul, header/footer). Dipakai Pandoc. |
| `make-reference-docx.py` | Pembangun `reference.docx`; membaca brand dari `doc-fsd.config.yml`. |
| `build-docx.ps1` | Satu perintah konversi `.md` → `.docx`. |
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

Sebelum konversi (terutama salinan klien), lakukan pemangkasan pada **salinan**
(biar master `.md` tetap utuh untuk dibaca di GitHub):

1. **Isi metadata sampul** — blok YAML `---` di paling atas file (judul, modul,
   versi, tanggal, penyusun, klien). Inilah **halaman sampul**.
2. **Hapus blok "Daftar Isi" manual** — Word membuatnya otomatis (`--toc`);
   membiarkannya = Daftar Isi ganda.
3. Pastikan semua diagram sudah PNG (Pandoc meng-embed PNG, bukan `.mmd`).

### 2. Konversi

```powershell
./build-docx.ps1 <path>/fsd-<modul>.md -Out <path>/FSD-Modul-<Modul>.docx
```

Buka di Word; bila Daftar Isi belum terisi, klik kanan → **Update Field**.

Opsi:
```powershell
./build-docx.ps1 <input.md> -Out ./FSD-Khusus.docx   # nama output manual
./build-docx.ps1 <input.md> -TocDepth 3               # sertakan sub-sub-bab
```

---

## Yang dihasilkan `reference.docx`

- **Halaman sampul** dari metadata: judul, subjudul, penyusun, tanggal — terpusat.
- **Daftar Isi** otomatis (mulai halaman baru).
- **Heading berwarna brand** (font judul), isi font body 11pt, spasi 1.15.
- **Setiap BAB mulai di halaman baru** (page-break otomatis pada Heading 1).
- **Perataan**: paragraf isi rata kanan-kiri (justify); teks dalam sel tabel rata
  kiri; gambar & blok tabel rata tengah.
- **Tabel**: grid tipis, baris header berlatar warna brand + teks putih.
- **Header/footer**: label dokumen (dari `project.*`) + "Halaman X dari Y".

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
> `reference.docx`; isi body-nya diabaikan.

---

## Kenapa tidak "cover page di Markdown saja"?

Markdown tak punya kendali atas font, warna, gaya tabel, header/footer, atau
nomor halaman Word. Sampul dan tampilan profesional **hanya bisa** diwujudkan di
lapisan konversi (`reference.docx`) — bukan di body `.md`. Pendekatan ini menjaga
`.md` tetap bersih & mudah dibaca, sementara polesan tampilan terpusat di satu
template yang dipakai ulang semua FSD.
