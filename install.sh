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

# ── Run setup wizard ──────────────────────────────────────────────────────
echo ""
yellow "  Run the setup wizard now? It takes ~2 minutes and personalizes"
yellow "  zi for your workflow, detects your tools, and gets you ready to go."
echo ""
printf "  Run zi setup? [Y/n] "
read -r run_setup
if [[ "$run_setup" != n && "$run_setup" != N ]]; then
  export PATH="$ZI_BIN:$PATH"
  exec "$ZI_BIN/zi" setup
else
  green "  zi installed successfully!"
  echo ""
  echo "  Restart your shell or run:  source $ZSHRC"
  echo "  Then run:                   zi setup"
  echo ""
fi
