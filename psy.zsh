# psy.zsh — shell integration for psy
# Source this in your .zshrc:
#   source ~/.config/psy/psy.zsh
# Or the installer handles it automatically.

# ── Tab completion ─────────────────────────────────────────────────────────
_psy_comp_dir="${XDG_CONFIG_HOME:-$HOME/.config}/psy"
[[ -f "$_psy_comp_dir/_psy" ]] && fpath=("$_psy_comp_dir" $fpath)
autoload -Uz compinit && compinit -C 2>/dev/null
compdef _psy psy 2>/dev/null
unset _psy_comp_dir

# ── psy shell wrapper ───────────────────────────────────────────────────────
function psy() {
  local known_subcommands=(ask fix "?" run man log watch explain desc code edit agent chat setup update uninstall version --version -v _route _palette _entries _correct)

  if [[ -z "$1" ]]; then
    local result
    result=$(command psy _palette </dev/tty 2>/dev/tty)
    [[ -z "$result" ]] && return 0
    if echo "$result" | grep -q '<'; then
      print -z "$result"       # has placeholder — load into buffer for editing
    else
      print -s "$result"       # add to shell history
      eval "$result"
    fi
  elif (( ${known_subcommands[(Ie)$1]} )); then
    command psy "$@"
  else
    command psy _route "$*"     # plain text — smart intent routing
  fi
}

# ── Ctrl+Space: AI-correct current buffer ─────────────────────────────────
function _psy_correct_buffer() {
  [[ -z "$BUFFER" ]] && return
  zle -R "psy: correcting..."
  local corrected
  corrected=$(command psy _correct "$BUFFER" 2>/dev/null)
  if [[ -n "$corrected" && "$corrected" != "$BUFFER" ]]; then
    BUFFER="$corrected"
    CURSOR=${#BUFFER}
  fi
  zle reset-prompt
}
zle -N _psy_correct_buffer
bindkey '^ ' _psy_correct_buffer

# ── preexec: track last command for psy fix context ────────────────────────
# Saves the command to a file so psy fix has the right context even without Atuin
function _psy_preexec() {
  local _psy_data_dir="${XDG_DATA_HOME:-$HOME/.local/share}/psy"
  [[ -d "$_psy_data_dir" ]] && printf '%s' "$1" > "$_psy_data_dir/last_cmd"
}
preexec_functions+=(_psy_preexec)

# ── psy watch: auto-fix on non-zero exit ───────────────────────────────────
_psy_watch_active=0
function _psy_watch_precmd() {
  local last_exit=$?
  if [[ $last_exit -ne 0 && -f "$HOME/.psy_watch" && $_psy_watch_active -eq 0 ]]; then
    _psy_watch_active=1
    psy fix
    _psy_watch_active=0
  fi
}
precmd_functions+=(_psy_watch_precmd)
