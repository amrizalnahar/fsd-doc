<#
    install.ps1 - Padanan Windows dari install.sh. Pasang 3 skill FSD
    (fsd-init, fsd-doc, fsd-convert) ke direktori skill Claude Code sehingga
    /fsd-init, /fsd-doc, /fsd-convert langsung aktif.

    Pemakaian:
        ./install.ps1               # symlink (butuh Developer Mode/admin), fallback copy
        ./install.ps1 -Copy         # paksa SALIN (tanpa symlink; paling aman)
        ./install.ps1 -Link         # paksa SYMLINK (gagal -> error)
        ./install.ps1 -Force        # timpa folder skill yang sudah ada
        ./install.ps1 -Uninstall    # lepas ketiga skill

    Target: $env:CLAUDE_CONFIG_DIR\skills bila diset, selain itu
    $env:USERPROFILE\.claude\skills. Update setelah 'git pull': jalankan lagi.
#>
param(
    [switch]$Copy,
    [switch]$Link,
    [switch]$Force,
    [switch]$Uninstall
)

$ErrorActionPreference = "Stop"
$skills  = @("fsd-init", "fsd-doc", "fsd-convert")
$srcDir  = Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) "skills"
$base    = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $env:USERPROFILE ".claude" }
$destDir = Join-Path $base "skills"

function Uninstall-One($name) {
    $dest = Join-Path $destDir $name
    if (Test-Path $dest) {
        Remove-Item $dest -Recurse -Force
        Write-Host "  [ok] lepas $name" -ForegroundColor Green
    } else {
        Write-Host "  [-]  $name tidak terpasang" -ForegroundColor DarkGray
    }
}

function Install-One($name) {
    $src  = Join-Path $srcDir $name
    $dest = Join-Path $destDir $name
    if (-not (Test-Path (Join-Path $src "SKILL.md"))) {
        Write-Host "  [x] sumber tidak valid: $src" -ForegroundColor Red; return
    }

    if (Test-Path $dest) {
        $item = Get-Item $dest -Force
        $isLink = $item.Attributes -band [IO.FileAttributes]::ReparsePoint
        $isSkill = Test-Path (Join-Path $dest "SKILL.md")
        if ($isLink -or $isSkill -or $Force) {
            Remove-Item $dest -Recurse -Force
        } else {
            Write-Host "  [!]  lewati $name - sudah ada folder non-skill di $dest (pakai -Force untuk timpa)" -ForegroundColor Yellow
            return
        }
    }

    $mode = if ($Copy) { "copy" } elseif ($Link) { "link" } else { "auto" }
    if ($mode -eq "copy") {
        Copy-Item $src $dest -Recurse
        Write-Host "  [ok] copy $name -> $dest" -ForegroundColor Green
        return
    }
    try {
        New-Item -ItemType SymbolicLink -Path $dest -Target $src -ErrorAction Stop | Out-Null
        Write-Host "  [ok] link $name -> $dest" -ForegroundColor Green
    } catch {
        if ($mode -eq "link") { throw }
        Copy-Item $src $dest -Recurse
        Write-Host "  [ok] copy $name -> $dest (symlink tak tersedia, disalin)" -ForegroundColor Green
    }
}

if ($Uninstall) {
    Write-Host "Melepas skill FSD dari: $destDir"
    foreach ($s in $skills) { Uninstall-One $s }
    Write-Host "Selesai."
    return
}

Write-Host "Memasang skill FSD"
Write-Host "  sumber : $srcDir"
Write-Host "  target : $destDir"
if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
foreach ($s in $skills) { Install-One $s }
Write-Host ""
Write-Host "Selesai. Restart Claude Code, lalu ketik /fsd- untuk memastikan"
Write-Host "/fsd-init, /fsd-doc, /fsd-convert muncul."
