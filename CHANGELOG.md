# Changelog

All notable changes to zi are documented here.

---

## [0.1.0] — 2026-03-26

Initial public release.

### Core modes
- `zi` — fzf command palette with 30+ built-in entries
- `zi <anything>` — intent router (auto-classifies plain text to the right mode)
- `zi ask` — natural language → shell command via Groq
- `zi fix` — explain and fix last failed command (Atuin → preexec → fc fallback chain)
- `zi desc` — plain-English explanation of any command or snippet
- `zi code` — code generation (Claude CLI if available, else Groq)
- `zi edit` — Claude edits files autonomously (`acceptEdits` mode)
- `zi agent` — fully autonomous Claude (edits files + runs commands, `bypassPermissions`)
- `zi explain` — explain what a file does
- `zi man` — 10-bullet practical man page summary
- `zi ?` — explain terminal output
- `zi run` — run a command and copy output to clipboard
- `zi log` — browse recent queries with optional filter
- `zi chat` — persistent multi-turn conversations (named sessions, JSONL storage)
- `zi chat list` — list saved sessions
- `zi chat delete` — delete a saved session
- `zi watch on|off` — auto-run `zi fix` on non-zero exit
- `zi update` — self-update binary + zi.zsh from GitHub
- `zi uninstall` — clean removal (binary, config, data, .zshrc line)
- `zi setup` — interactive onboarding wizard (see below)
- `zi version` — show current version

### Setup wizard (`zi setup`)
Five-step interactive onboarding:
1. Experience level — beginner mode adds explanations throughout
2. Groq API key — free at console.groq.com, saved to .zshrc
3. Workflow — web / backend / devops / data / general
4. Terminal tools — tiered installer (Essential / Recommended / Power Tools) with before/after explanations and batch install prompts
5. Personalized palette — generates workflow-specific command palette entries

### Shell integration (`zi.zsh`)
- `zi()` wrapper with intent routing
- `Ctrl+Space` — ZLE widget: AI-corrects current buffer in-place, no Enter needed
- `_zi_preexec` hook — tracks last command for `zi fix` context
- `_zi_watch_precmd` hook — auto-fix on non-zero exit when watch is on
- Tab completion (`_zi`) — subcommands, session names, file args, on/off states

### Installer (`install.sh`)
- Shell check — warns and prompts if `$SHELL` is not zsh
- Downloads binary, zi.zsh, and `_zi` completion
- Patches `~/.zshrc` with PATH and source line (idempotent)
- Prints clear next steps (no `exec` or interactive prompts in pipe context)

### Architecture
- Single zsh script, no compiled dependencies
- Groq API (`llama-3.3-70b-versatile`) for fast/free inference
- Claude Code CLI for `edit`, `agent`, `code` modes (optional, auto-detected)
- Post-edit diff display: delta → bat → git diff fallback
- Chat sessions: JSONL, 40-message cap, context re-injected per turn
- XDG-compliant paths throughout
- VERSION file for CDN-safe self-update version checks
