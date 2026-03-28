# Changelog

All notable changes to psy are documented here.

---

## [0.1.0] — 2026-03-26

Initial public release.

### Core modes
- `psy` — fzf command palette with 30+ built-in entries
- `psy <anything>` — intent router (auto-classifies plain text to the right mode)
- `psy ask` — natural language → shell command via Groq
- `psy fix` — explain and fix last failed command (Atuin → preexec → fc fallback chain)
- `psy desc` — plain-English explanation of any command or snippet
- `psy code` — code generation (Claude CLI if available, else Groq)
- `psy edit` — Claude edits files autonomously (`acceptEdits` mode)
- `psy agent` — fully autonomous Claude (edits files + runs commands, `bypassPermissions`)
- `psy explain` — explain what a file does
- `psy man` — 10-bullet practical man page summary
- `psy ?` — explain terminal output
- `psy run` — run a command and copy output to clipboard
- `psy log` — browse recent queries with optional filter
- `psy chat` — persistent multi-turn conversations (named sessions, JSONL storage)
- `psy chat list` — list saved sessions
- `psy chat delete` — delete a saved session
- `psy watch on|off` — auto-run `psy fix` on non-zero exit
- `psy update` — self-update binary + psy.zsh from GitHub
- `psy uninstall` — clean removal (binary, config, data, .zshrc line)
- `psy setup` — interactive onboarding wizard (see below)
- `psy version` — show current version

### Setup wizard (`psy setup`)
Five-step interactive onboarding:
1. Experience level — beginner mode adds explanations throughout
2. Groq API key — free at console.groq.com, saved to .zshrc
3. Workflow — web / backend / devops / data / general
4. Terminal tools — tiered installer (Essential / Recommended / Power Tools) with before/after explanations and batch install prompts
5. Personalized palette — generates workflow-specific command palette entries

### Shell integration (`psy.zsh`)
- `psy()` wrapper with intent routing
- `Ctrl+Space` — ZLE widget: AI-corrects current buffer in-place, no Enter needed
- `_psy_preexec` hook — tracks last command for `psy fix` context
- `_psy_watch_precmd` hook — auto-fix on non-zero exit when watch is on
- Tab completion (`_psy`) — subcommands, session names, file args, on/off states

### Installer (`install.sh`)
- Shell check — warns and prompts if `$SHELL` is not zsh
- Downloads binary, psy.zsh, and `_psy` completion
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
