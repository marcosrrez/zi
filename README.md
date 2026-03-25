# zi — terminal intelligence

> One command. Any intent. zi figures out the rest.

zi is a zsh shell intelligence layer. Type naturally — it routes your intent to the right tool automatically. Need a shell command? A code explanation? A bug fix? An autonomous coding agent? Just type.

```
zi why is my docker container crashing
zi git log --oneline --graph -20
zi add input validation to server.js
zi write a script to sync my dotfiles
```

Powered by [Groq](https://console.groq.com) (free tier, ~300ms) for quick queries, and optionally [Claude Code](https://claude.ai/code) for complex coding tasks.

---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/marcosrrez/zi/main/install.sh | bash
```

Then restart your shell. That's it.

**Requirements:** zsh, curl, python3, fzf

---

## What zi does

| Command | What happens |
|---|---|
| `zi` | fzf command palette — browse and run common commands |
| `zi <anything>` | Smart routing — zi figures out what you mean |
| `zi ask <q>` | Natural language → shell command |
| `zi code <task>` | Generate code (Claude CLI if available, else Groq) |
| `zi edit <task>` | Claude edits your files autonomously (prompts before bash) |
| `zi agent <task>` | Claude fully autonomous — edits files and runs commands |
| `zi desc <cmd>` | Plain English explanation of any command or snippet |
| `zi fix` | Explain and fix your last error |
| `zi man <cmd>` | 10-bullet practical man page summary |
| `zi ? <text>` | Explain terminal output |
| `zi explain <file>` | Explain what a file does |
| `zi run <cmd>` | Run a command and copy output to clipboard |
| `zi log [filter]` | Browse recent zi queries |
| `zi chat [session]` | Persistent multi-turn conversation with context |
| `zi chat list` | List all saved chat sessions |
| `zi watch on\|off` | Auto-run `zi fix` whenever a command fails |
| `zi update` | Update zi to the latest version |
| `zi version` | Show current version |

**Keyboard shortcut:** `Ctrl+Space` — AI-correct the current command buffer in-place.

---

## Intent routing

When you type `zi <anything>` without a subcommand, zi classifies your intent automatically:

| What you type | Routes to |
|---|---|
| A file path that exists | `zi explain` |
| "why did my build fail" | `zi fix` |
| "what does git rebase -i do" | `zi desc` |
| `git log --oneline` (bare command) | `zi desc` |
| "add error handling to server.js" | `zi edit` |
| "write a script to backup my files" | `zi code` |
| Anything else | `zi ask` |

---

## Coding modes

zi has three levels of coding assistance, depending on how much autonomy you want:

**`zi code`** — generates code and prints it. No files are touched. Uses Claude CLI if installed, otherwise Groq.

**`zi edit`** — opens a Claude session with `acceptEdits` mode. Claude reads your codebase and edits files directly. It will still ask before running any shell commands.

**`zi agent`** — fully autonomous. Claude edits files and runs commands without prompting. Shows a warning and requires confirmation before starting.

> `zi edit` and `zi agent` require [Claude Code](https://claude.ai/code) to be installed.

---

## Setup

### Groq API key (required for most features)

Get a free key at [console.groq.com](https://console.groq.com), then:

```bash
export GROQ_API_KEY="your-key-here"
```

Add to your `.zshrc` to persist it.

### Claude CLI (optional, for `zi code`, `zi edit`, `zi agent`)

Install [Claude Code](https://claude.ai/code). zi will detect it automatically.

You can also point zi to a custom path:

```bash
export ZI_CLAUDE="/path/to/claude"
```

### Custom palette entries

Create `~/.config/zi/palette` with entries in `category|command|description` format:

```
dev     |npm run dev                   |Start dev server
git     |git push --force-with-lease   |Safe force push
```

These are appended to zi's default palette.

---

## Configuration

| Variable | Default | Description |
|---|---|---|
| `GROQ_API_KEY` | — | Groq API key |
| `ZI_GROQ_KEY` | — | Alternative key variable |
| `ZI_MODEL` | `llama-3.3-70b-versatile` | Groq model to use |
| `ZI_CLAUDE` | auto-detected | Path to claude binary |

---

## How it works

zi is a single zsh script (~300 lines) with no runtime dependencies beyond what you already have. It:

1. Detects which tools are installed on your machine and injects them into every prompt as context
2. Uses Groq's API for fast, free inference on quick queries
3. Shells out to Claude Code's CLI for tasks that need real coding power
4. Integrates with your shell natively — ZLE widget for Ctrl+Space, precmd hook for `zi watch`, fzf for the palette
5. Logs everything to `~/.local/share/zi/history.jsonl`

---

## Customizing the palette

The command palette (`zi` with no args) shows categorized commands you can browse with fzf. The defaults cover common git, navigation, file, and dev workflows.

To add your own entries, create `~/.config/zi/palette`:

```
# format: category|command|description
work    |ssh deploy@prod               |SSH into production
db      |psql -U postgres mydb         |Connect to local Postgres
k8s     |kubectl get pods -A           |List all pods
```

---

## License

MIT — see [LICENSE](LICENSE)
