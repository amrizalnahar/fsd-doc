<#
    build-docx.ps1 — Konversi satu FSD Markdown menjadi .docx ber-brand (warna
    dari reference.docx; lihat make-reference-docx.py + doc-fsd.config.yml).

    Contoh:
        ./build-docx.ps1 <path>/fsd-applicant.md
        ./build-docx.ps1 <path>/fsd-applicant.md -Out ./FSD-Modul-Applicant.docx
        ./build-docx.ps1 <path>/fsd-applicant.md -Reference ./client-reference.docx

    Prasyarat:
        - Pandoc terpasang         : https://pandoc.org/installing.html
                                     (Windows: winget install --id JohnMacFarlane.Pandoc)
        - reference.docx ada di folder ini (regenerate: py make-reference-docx.py)
          — atau tunjuk template kustom lewat -Reference (mis. docx.reference config).

    Catatan:
        - Penomoran BAB/sub-bab sudah manual di .md → JANGAN pakai --number-sections.
        - Daftar Isi dibuat otomatis oleh Word via --toc. Hapus blok "Daftar Isi"
          manual & baris header ganda pada salinan yang dikonversi (lihat README).
        - Diagram harus sudah berupa PNG dan link Markdown harus relatif terhadap
          folder Markdown agar dapat ter-embed.
        - Blok <!-- INTERNAL:START --> ... <!-- INTERNAL:END --> dipangkas OTOMATIS
          dari salinan yang dikonversi (tidak pernah ikut ke .docx klien).
        - Semua referensi gambar lokal divalidasi sebelum Pandoc dipanggil; skrip
          berhenti (fail-fast) bila ada aset yang hilang, alih-alih diam-diam
          mengganti gambar dengan teks alt.
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$InputMd,

    [string]$Out,

    [int]$TocDepth = 2,

    [string]$Reference
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
if (-not $Reference) {
    $Reference = Join-Path $here "reference.docx"
}
if (-not (Test-Path $Reference)) {
    Write-Host "[x] reference.docx tidak ada: $Reference" -ForegroundColor Red
    Write-Host "    Jalankan: py make-reference-docx.py (atau perbaiki path -Reference / docx.reference)" -ForegroundColor Yellow
    exit 1
}

# --- tentukan output
# Nama file mengikuti pola FSD-Modul-{scope}. Untuk pemakaian manual, buang
# awalan dokumentasi aktual "fsd-" (kompatibel pula dengan "fsd-master-").
# Separator role-set "--" diterjemahkan ke "-Dan-":
# fsd-admin-ta--applicant.md -> FSD-Modul-Admin-Ta-Dan-Applicant.docx.
# High-level /fsd-convert selalu disarankan mengirim -Out eksplisit.
if (-not $Out) {
    $base = [System.IO.Path]::GetFileNameWithoutExtension($InputMd)
    $scope = $base -replace '^(?i)fsd-master-', ''
    $scope = $scope -replace '^(?i)fsd-', ''
    $scope = $scope -replace '--', '-Dan-'
    # Kapitalkan tiap segmen antar-tanda-hubung: admin-ta -> Admin-Ta, public -> Public
    $scope = ($scope -split '-' | ForEach-Object {
        if ($_.Length -gt 0) { $_.Substring(0,1).ToUpper() + $_.Substring(1) } else { $_ }
    }) -join '-'
    $Out = Join-Path (Split-Path -Parent (Resolve-Path $InputMd)) "FSD-Modul-$scope.docx"
}

# --- resource-path agar gambar relatif (./images/...) ketemu
$mdDir = Split-Path -Parent (Resolve-Path $InputMd)

Write-Host "[>] Konversi : $InputMd" -ForegroundColor Cyan
Write-Host "[>] Referensi: $Reference" -ForegroundColor Cyan
Write-Host "[>] Output   : $Out" -ForegroundColor Cyan

# --- pangkas blok INTERNAL (audit-only, TIDAK boleh sampai ke klien) ---------
# Dilakukan di sini (bukan diandalkan ke Pandoc, yang hanya membuang komentar
# HTML-nya, bukan isi blok) agar setiap pemanggilan build-docx.ps1 aman by
# default, termasuk dari flow manual.
$content = Get-Content -Path $InputMd -Raw -Encoding UTF8
$internalPattern = '(?s)<!--\s*INTERNAL:START\s*-->.*?<!--\s*INTERNAL:END\s*-->'
$converted = [regex]::Replace($content, $internalPattern, '')

if ($converted -match '<!--\s*INTERNAL:(START|END)\s*-->') {
    Write-Host "[x] Marker INTERNAL tidak berpasangan tersisa setelah pemangkasan." -ForegroundColor Red
    Write-Host "    Periksa pasangan <!-- INTERNAL:START --> ... <!-- INTERNAL:END --> di: $InputMd" -ForegroundColor Yellow
    exit 1
}

# --- validasi semua referensi gambar lokal SEBELUM Pandoc (fail-fast) -------
# Pandoc hanya mencetak warning saat resource hilang lalu tetap "berhasil"
# dengan gambar diam-diam diganti teks alt. Ini menggagalkan proses sedini
# mungkin dengan pesan yang menyebut path yang salah.
$imgMatches = [regex]::Matches($converted, '!\[[^\]]*\]\(\s*<?([^)\s>]+)>?[^)]*\)')
$missing = @()
foreach ($m in $imgMatches) {
    $imgPath = $m.Groups[1].Value
    if ($imgPath -match '^([a-zA-Z][a-zA-Z0-9+.-]*:)?//') { continue }  # URL remote
    $resolved = Join-Path $mdDir $imgPath
    if (-not (Test-Path $resolved)) {
        $missing += $imgPath
    }
}
if ($missing.Count -gt 0) {
    Write-Host "[x] $($missing.Count) referensi gambar tidak ditemukan (relatif terhadap $mdDir):" -ForegroundColor Red
    foreach ($m in $missing) { Write-Host "    - $m" -ForegroundColor Yellow }
    exit 1
}

# --- tulis salinan yang sudah dipangkas ke file sementara untuk dikonversi ---
$tempMd = Join-Path ([System.IO.Path]::GetTempPath()) ("build-docx-" + [guid]::NewGuid().ToString() + ".md")
Set-Content -Path $tempMd -Value $converted -Encoding UTF8 -NoNewline

try {
    pandoc $tempMd `
        --from="markdown+yaml_metadata_block+pipe_tables+implicit_figures" `
        --reference-doc="$Reference" `
        --toc --toc-depth=$TocDepth `
        --resource-path="$mdDir" `
        --embed-resources=false `
        -o "$Out"
} finally {
    Remove-Item -Path $tempMd -ErrorAction SilentlyContinue
}

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
        & $py $harden $Out --reference $Reference
        if ($LASTEXITCODE -ne 0) {
            Write-Host "[!] Hardening header tabel dilewati/gagal - dokumen tetap benar di Word." -ForegroundColor Yellow
        }
    } else {
        Write-Host "[!] Python tak ditemukan - header tabel tak di-harden untuk Google Docs." -ForegroundColor Yellow
        Write-Host "    (Header putih tetap benar di Word. Untuk Google Docs: pasang Python + 'pip install python-docx'.)" -ForegroundColor DarkGray
    }

    # --- Rapikan ukuran & perataan gambar.
    #     Diagram Mermaid dirender skala tinggi (mmdc -s 3) agar tajam, tetapi Pandoc
    #     meng-embed pada ukuran native -> gambar bisa memenuhi 1 halaman penuh dan
    #     tak proporsional. Langkah ini membatasi UKURAN TAMPILAN saja (bukan resolusi
    #     PNG) dan memusatkan paragraf gambar. Rasio & piksel PNG utuh -> tetap tajam
    #     saat diperlebar. Butuh Python + python-docx; bila tak ada -> dilewati.
    $fit = Join-Path $here "fit-images.py"
    if ($py -and (Test-Path $fit)) {
        & $py $fit $Out
        if ($LASTEXITCODE -ne 0) {
            Write-Host "[!] Perapian ukuran gambar dilewati/gagal - dokumen tetap valid." -ForegroundColor Yellow
        }
    }

    # --- Sisipkan logo brand (brand.logo) di sampul, bila diatur di config.
    #     Pandoc mengabaikan isi body reference.docx, jadi logo tak bisa
    #     ditempel di sana - disisipkan di sini sebagai post-process. Tanpa
    #     brand.logo -> dilewati diam-diam (fitur opsional). brand.logo diisi
    #     tapi file tak ditemukan -> GAGAL build ini (bukan cuma warning),
    #     supaya salah path tidak diam-diam mengirim sampul klien tanpa logo.
    $logoScript = Join-Path $here "insert-logo.py"
    if ($py -and (Test-Path $logoScript)) {
        & $py $logoScript $Out
        if ($LASTEXITCODE -ne 0) {
            Write-Host "[x] Penyisipan logo brand gagal (lihat pesan di atas)." -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "[!] Python tak ditemukan - brand.logo (bila diatur) tak disisipkan ke sampul." -ForegroundColor Yellow
    }

    Write-Host "[ok] Selesai: $Out" -ForegroundColor Green
    Write-Host "     Buka di Word, klik kanan Daftar Isi > Update Field bila perlu." -ForegroundColor DarkGray
} else {
    Write-Host "[x] Pandoc gagal (exit $LASTEXITCODE)." -ForegroundColor Red
    exit $LASTEXITCODE
}
