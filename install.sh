#!/usr/bin/env bash
# zi installer
# Usage: curl -fsSL https://raw.githubusercontent.com/marcosrrez/zi/main/install.sh | bash

set -euo pipefail

ZI_BIN="${ZI_BIN:-$HOME/.local/bin}"
ZI_ZSH_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zi"
ZI_REPO="https://raw.githubusercontent.com/marcosrrez/zi/main"
ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"

green()  { printf '\033[0;32m%s\033[0m\n' "$*"; }
yellow() { printf '\033[0;33m%s\033[0m\n' "$*"; }
red()    { printf '\033[0;31m%s\033[0m\n' "$*"; }
dim()    { printf '\033[2m%s\033[0m\n' "$*"; }

echo ""
echo "  zi — terminal intelligence"
echo "  ─────────────────────────"
echo ""

# ── Check dependencies ─────────────────────────────────────────────────────
missing=()
for dep in zsh curl python3 fzf; do
  command -v "$dep" &>/dev/null || missing+=("$dep")
done
if [[ ${#missing[@]} -gt 0 ]]; then
  red "Missing required dependencies: ${missing[*]}"
  echo "Install them and re-run this script."
  exit 1
fi
green "  Dependencies OK"

# ── Install binary ─────────────────────────────────────────────────────────
mkdir -p "$ZI_BIN"
curl -fsSL "$ZI_REPO/zi" -o "$ZI_BIN/zi"
chmod +x "$ZI_BIN/zi"
green "  Installed zi to $ZI_BIN/zi"

# ── Install shell integration ──────────────────────────────────────────────
mkdir -p "$ZI_ZSH_DIR"
curl -fsSL "$ZI_REPO/zi.zsh" -o "$ZI_ZSH_DIR/zi.zsh"
green "  Installed zi.zsh to $ZI_ZSH_DIR/zi.zsh"
curl -fsSL "$ZI_REPO/_zi" -o "$ZI_ZSH_DIR/_zi"
green "  Installed _zi completion to $ZI_ZSH_DIR/_zi"

# ── Add to PATH if needed ──────────────────────────────────────────────────
if [[ ":$PATH:" != *":$ZI_BIN:"* ]]; then
  echo "" >> "$ZSHRC"
  echo "# zi" >> "$ZSHRC"
  echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$ZSHRC"
  green "  Added $ZI_BIN to PATH in $ZSHRC"
fi

# ── Source shell integration ───────────────────────────────────────────────
ZSHRC_SOURCE_LINE="source \"\${XDG_CONFIG_HOME:-\$HOME/.config}/zi/zi.zsh\""
if ! grep -qF "zi/zi.zsh" "$ZSHRC" 2>/dev/null; then
  echo "" >> "$ZSHRC"
  echo "# zi shell integration (palette, Ctrl+Space, watch)" >> "$ZSHRC"
  echo "$ZSHRC_SOURCE_LINE" >> "$ZSHRC"
  green "  Added zi.zsh source to $ZSHRC"
fi

# ── Done ──────────────────────────────────────────────────────────────────
echo ""
green "  zi installed successfully!"
echo ""
echo "  Next steps:"
echo "    1. Restart your shell:  source $ZSHRC"
echo "    2. Run the setup wizard: zi setup"
echo ""
echo "  The setup wizard will configure your API key, detect your tools,"
echo "  and personalize the command palette for your workflow."
echo ""
