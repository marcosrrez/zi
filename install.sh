#!/usr/bin/env bash
# psy installer
# Usage: curl -fsSL https://raw.githubusercontent.com/marcosrrez/psy/main/install.sh | bash

set -euo pipefail

# ── Shell check ─────────────────────────────────────────────────────────────
_current_shell="${SHELL##*/}"
if [[ "$_current_shell" != "zsh" ]]; then
  printf '\033[0;33m  Warning: your default shell is %s, not zsh.\033[0m\n' "$_current_shell"
  printf '\033[0;33m  psy'\''s shell integration (palette, Ctrl+Space, watch) requires zsh.\033[0m\n'
  echo ""
  echo "  To switch to zsh:"
  echo "    chsh -s \$(which zsh)"
  echo "  Then log out and back in, and re-run this installer."
  echo ""
  printf '  Continue installing anyway? [y/N] '
  read -r _shell_ans
  [[ "$_shell_ans" != y && "$_shell_ans" != Y ]] && exit 0
fi

PSY_BIN="${PSY_BIN:-$HOME/.local/bin}"
PSY_ZSH_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/psy"
PSY_REPO="https://raw.githubusercontent.com/marcosrrez/psy/main"
ZSHRC="${ZDOTDIR:-$HOME}/.zshrc"

green()  { printf '\033[0;32m%s\033[0m\n' "$*"; }
yellow() { printf '\033[0;33m%s\033[0m\n' "$*"; }
red()    { printf '\033[0;31m%s\033[0m\n' "$*"; }
dim()    { printf '\033[2m%s\033[0m\n' "$*"; }

echo ""
echo "  psy — terminal intelligence"
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
mkdir -p "$PSY_BIN"
curl -fsSL "$PSY_REPO/psy" -o "$PSY_BIN/psy"
chmod +x "$PSY_BIN/psy"
green "  Installed psy to $PSY_BIN/psy"

# ── Install shell integration ──────────────────────────────────────────────
mkdir -p "$PSY_ZSH_DIR"
curl -fsSL "$PSY_REPO/psy.zsh" -o "$PSY_ZSH_DIR/psy.zsh"
green "  Installed psy.zsh to $PSY_ZSH_DIR/psy.zsh"
curl -fsSL "$PSY_REPO/_psy" -o "$PSY_ZSH_DIR/_psy"
green "  Installed _psy completion to $PSY_ZSH_DIR/_psy"

# ── Add to PATH if needed ──────────────────────────────────────────────────
if [[ ":$PATH:" != *":$PSY_BIN:"* ]]; then
  echo "" >> "$ZSHRC"
  echo "# psy" >> "$ZSHRC"
  echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$ZSHRC"
  green "  Added $PSY_BIN to PATH in $ZSHRC"
fi

# ── Source shell integration ───────────────────────────────────────────────
ZSHRC_SOURCE_LINE="source \"\${XDG_CONFIG_HOME:-\$HOME/.config}/psy/psy.zsh\""
if ! grep -qF "psy/psy.zsh" "$ZSHRC" 2>/dev/null; then
  echo "" >> "$ZSHRC"
  echo "# psy shell integration (palette, Ctrl+Space, watch)" >> "$ZSHRC"
  echo "$ZSHRC_SOURCE_LINE" >> "$ZSHRC"
  green "  Added psy.zsh source to $ZSHRC"
fi

# ── Done ──────────────────────────────────────────────────────────────────
echo ""
green "  psy installed successfully!"
echo ""
echo "  Next steps:"
echo "    1. Restart your shell:  source $ZSHRC"
echo "    2. Run the setup wizard: psy setup"
echo ""
echo "  The setup wizard will configure your API key, detect your tools,"
echo "  and personalize the command palette for your workflow."
echo ""
