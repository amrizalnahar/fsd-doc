#!/usr/bin/env bash
# =============================================================================
#  install.sh — Pasang 3 skill FSD (fsd-init, fsd-doc, fsd-convert) ke direktori
#  skill Claude Code, sehingga /fsd-init, /fsd-doc, /fsd-convert langsung aktif.
#
#  Kenapa perlu: Claude Code hanya mengenali skill pada kedalaman tetap
#  ~/.claude/skills/<nama>/SKILL.md (2 tingkat), sedangkan git clone menaruhnya
#  lebih dalam (repo/skills/<nama>/). Skrip ini menautkan/menyalin tiap skill ke
#  tempat yang benar.
#
#  Pemakaian:
#      ./install.sh              # symlink (default; fallback copy bila gagal)
#      ./install.sh --copy       # paksa SALIN (tanpa symlink; aman di Windows)
#      ./install.sh --link       # paksa SYMLINK (gagal → error, tidak fallback)
#      ./install.sh --force      # timpa folder skill yang sudah ada
#      ./install.sh --uninstall  # lepas ketiga skill dari direktori skill
#
#  Target direktori: $CLAUDE_CONFIG_DIR/skills bila diset, selain itu
#  ~/.claude/skills. Update setelah `git pull`: cukup `./install.sh` lagi.
# =============================================================================
set -euo pipefail

SKILLS=("fsd-init" "fsd-doc" "fsd-convert")

# root repo = folder skrip ini → aset skill ada di ./skills/
SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skills"
DEST_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills"

MODE="auto"       # auto | link | copy
FORCE=0
UNINSTALL=0

for arg in "$@"; do
  case "$arg" in
    --copy)      MODE="copy" ;;
    --link)      MODE="link" ;;
    --force)     FORCE=1 ;;
    --uninstall) UNINSTALL=1 ;;
    -h|--help)
      grep '^#' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//; s/^#//'
      exit 0 ;;
    *) echo "Argumen tak dikenal: $arg (lihat --help)" >&2; exit 1 ;;
  esac
done

uninstall_one() {
  local name="$1"
  local dest="$DEST_DIR/$name"
  if [[ -L "$dest" || -e "$dest" ]]; then
    rm -rf "$dest"; echo "  [ok] lepas $name"
  else
    echo "  [-]  $name tidak terpasang"
  fi
}

install_one() {
  local name="$1"
  local src="$SRC_DIR/$name"
  local dest="$DEST_DIR/$name"

  if [[ ! -f "$src/SKILL.md" ]]; then
    echo "  [x] sumber tidak valid (tak ada SKILL.md): $src" >&2; return 1
  fi

  # bersihkan target lama: symlink atau folder skill kita (berisi SKILL.md) boleh
  # diganti; konten asing lain hanya bila --force.
  if [[ -L "$dest" ]]; then
    rm -f "$dest"
  elif [[ -e "$dest" ]]; then
    if [[ "$FORCE" -eq 1 || -f "$dest/SKILL.md" ]]; then
      rm -rf "$dest"
    else
      echo "  [!]  lewati $name — sudah ada folder non-skill di $dest (pakai --force untuk timpa)"; return 0
    fi
  fi

  case "$MODE" in
    copy) cp -R "$src" "$dest"; echo "  [ok] copy $name -> $dest" ;;
    link) ln -s "$src" "$dest"; echo "  [ok] link $name -> $dest" ;;
    auto)
      if ln -s "$src" "$dest" 2>/dev/null && [[ -e "$dest/SKILL.md" ]]; then
        echo "  [ok] link $name -> $dest"
      else
        rm -rf "$dest" 2>/dev/null || true
        cp -R "$src" "$dest"; echo "  [ok] copy $name -> $dest (symlink tak tersedia, disalin)"
      fi ;;
  esac
}

if [[ "$UNINSTALL" -eq 1 ]]; then
  echo "Melepas skill FSD dari: $DEST_DIR"
  for s in "${SKILLS[@]}"; do uninstall_one "$s"; done
  echo "Selesai."
  exit 0
fi

echo "Memasang skill FSD"
echo "  sumber : $SRC_DIR"
echo "  target : $DEST_DIR"
mkdir -p "$DEST_DIR"
for s in "${SKILLS[@]}"; do install_one "$s"; done
echo
echo "Selesai. Restart Claude Code, lalu ketik /fsd- untuk memastikan"
echo "/fsd-init, /fsd-doc, /fsd-convert muncul."
