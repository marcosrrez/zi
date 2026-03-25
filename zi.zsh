# zi.zsh — shell integration for zi
# Source this in your .zshrc:
#   source ~/.config/zi/zi.zsh
# Or the installer handles it automatically.

# ── zi shell wrapper ───────────────────────────────────────────────────────
function zi() {
  local known_subcommands=(ask fix "?" run man log watch explain desc code edit agent chat setup update version --version -v _route _palette _entries _correct)

  if [[ -z "$1" ]]; then
    local result
    result=$(command zi _palette 2>/dev/null)
    [[ -z "$result" ]] && return 0
    if echo "$result" | grep -q '<'; then
      print -z "$result"       # has placeholder — load into buffer for editing
    else
      print -s "$result"       # add to shell history
      eval "$result"
    fi
  elif (( ${known_subcommands[(Ie)$1]} )); then
    command zi "$@"
  else
    command zi _route "$*"     # plain text — smart intent routing
  fi
}

# ── Ctrl+Space: AI-correct current buffer ─────────────────────────────────
function _zi_correct_buffer() {
  [[ -z "$BUFFER" ]] && return
  zle -R "zi: correcting..."
  local corrected
  corrected=$(command zi _correct "$BUFFER" 2>/dev/null)
  if [[ -n "$corrected" && "$corrected" != "$BUFFER" ]]; then
    BUFFER="$corrected"
    CURSOR=${#BUFFER}
  fi
  zle reset-prompt
}
zle -N _zi_correct_buffer
bindkey '^ ' _zi_correct_buffer

# ── preexec: track last command for zi fix context ────────────────────────
# Saves the command to a file so zi fix has the right context even without Atuin
function _zi_preexec() {
  local _zi_data_dir="${XDG_DATA_HOME:-$HOME/.local/share}/zi"
  [[ -d "$_zi_data_dir" ]] && printf '%s' "$1" > "$_zi_data_dir/last_cmd"
}
preexec_functions+=(_zi_preexec)

# ── zi watch: auto-fix on non-zero exit ───────────────────────────────────
_zi_watch_active=0
function _zi_watch_precmd() {
  local last_exit=$?
  if [[ $last_exit -ne 0 && -f "$HOME/.zi_watch" && $_zi_watch_active -eq 0 ]]; then
    _zi_watch_active=1
    zi fix
    _zi_watch_active=0
  fi
}
precmd_functions+=(_zi_watch_precmd)
