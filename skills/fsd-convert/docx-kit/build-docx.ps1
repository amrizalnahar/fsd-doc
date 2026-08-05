<#
    build-docx.ps1 — Konversi satu FSD Markdown menjadi .docx ber-brand (warna
    dari reference.docx; lihat make-reference-docx.py + doc-fsd.config.yml).

    Contoh:
        ./build-docx.ps1 <path>/fsd-applicant.md
        ./build-docx.ps1 <path>/fsd-applicant.md -Out ./FSD-Modul-Applicant.docx

    Prasyarat:
        - Pandoc terpasang         : https://pandoc.org/installing.html
                                     (Windows: winget install --id JohnMacFarlane.Pandoc)
        - reference.docx ada di folder ini (regenerate: py make-reference-docx.py)

    Catatan:
        - Penomoran BAB/sub-bab sudah manual di .md → JANGAN pakai --number-sections.
        - Daftar Isi dibuat otomatis oleh Word via --toc. Hapus blok "Daftar Isi"
          manual & baris header ganda pada salinan yang dikonversi (lihat README).
        - Diagram harus sudah berupa PNG di ./images/ agar ter-embed.
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$InputMd,

    [string]$Out,

    [int]$TocDepth = 2
)

$ErrorActionPreference = "Stop"
$here = Split-Path -Parent $MyInvocation.MyCommand.Path

# --- validasi pandoc
if (-not (Get-Command pandoc -ErrorAction SilentlyContinue)) {
    Write-Host "[x] Pandoc belum terpasang." -ForegroundColor Red
    Write-Host "    Install: winget install --id JohnMacFarlane.Pandoc" -ForegroundColor Yellow
    exit 1
}

# --- validasi input & reference
if (-not (Test-Path $InputMd)) {
    Write-Host "[x] File Markdown tidak ditemukan: $InputMd" -ForegroundColor Red
    exit 1
}
$reference = Join-Path $here "reference.docx"
if (-not (Test-Path $reference)) {
    Write-Host "[x] reference.docx tidak ada. Jalankan: py make-reference-docx.py" -ForegroundColor Red
    exit 1
}

# --- tentukan output
# Nama file mengikuti pola FSD-Modul-{nama-modul}, di mana {nama-modul} diambil
# dari nama .md dengan membuang awalan "fsd-master-" (mis. fsd-master-admin-ta.md
# -> FSD-Modul-admin-ta.docx). Bila tak ada awalan itu, dipakai nama dasar apa adanya.
if (-not $Out) {
    $base = [System.IO.Path]::GetFileNameWithoutExtension($InputMd)
    $modul = $base -replace '^(?i)fsd-master-', ''
    # Kapitalkan tiap segmen antar-tanda-hubung: admin-ta -> Admin-Ta, public -> Public
    $modul = ($modul -split '-' | ForEach-Object {
        if ($_.Length -gt 0) { $_.Substring(0,1).ToUpper() + $_.Substring(1) } else { $_ }
    }) -join '-'
    $Out = Join-Path (Split-Path -Parent (Resolve-Path $InputMd)) "FSD-Modul-$modul.docx"
}

# --- resource-path agar gambar relatif (./images/...) ketemu
$mdDir = Split-Path -Parent (Resolve-Path $InputMd)

Write-Host "[>] Konversi : $InputMd" -ForegroundColor Cyan
Write-Host "[>] Referensi: $reference" -ForegroundColor Cyan
Write-Host "[>] Output   : $Out" -ForegroundColor Cyan

pandoc $InputMd `
    --from="markdown+yaml_metadata_block+pipe_tables+implicit_figures" `
    --reference-doc="$reference" `
    --toc --toc-depth=$TocDepth `
    --resource-path="$mdDir" `
    --embed-resources=false `
    -o "$Out"

if ($LASTEXITCODE -eq 0) {
    # --- Hardening header tabel untuk portabilitas (Google Docs).
    #     Warna header dari reference.docx dipasang lewat conditional formatting
    #     gaya tabel (tblStylePr firstRow). Word menghormatinya, tetapi Google Docs
    #     MENGABAIKANNYA saat impor -> teks putih jadi hitam. Langkah ini membaking
    #     teks putih + latar brand sebagai DIRECT formatting agar konsisten di mana
    #     pun dokumen dibuka. Butuh Python + python-docx; bila tak ada -> dilewati
    #     (dokumen tetap valid & benar di Word).
    $harden = Join-Path $here "harden-table-headers.py"
    $py = $null
    foreach ($cmd in @("py", "python", "python3")) {
        if (Get-Command $cmd -ErrorAction SilentlyContinue) { $py = $cmd; break }
    }
    if ($py -and (Test-Path $harden)) {
        & $py $harden $Out --reference $reference
        if ($LASTEXITCODE -ne 0) {
            Write-Host "[!] Hardening header tabel dilewati/gagal - dokumen tetap benar di Word." -ForegroundColor Yellow
        }
    } else {
        Write-Host "[!] Python tak ditemukan - header tabel tak di-harden untuk Google Docs." -ForegroundColor Yellow
        Write-Host "    (Header putih tetap benar di Word. Untuk Google Docs: pasang Python + 'pip install python-docx'.)" -ForegroundColor DarkGray
    }

    Write-Host "[ok] Selesai: $Out" -ForegroundColor Green
    Write-Host "     Buka di Word, klik kanan Daftar Isi > Update Field bila perlu." -ForegroundColor DarkGray
} else {
    Write-Host "[x] Pandoc gagal (exit $LASTEXITCODE)." -ForegroundColor Red
    exit $LASTEXITCODE
}
