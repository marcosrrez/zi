# zi — terminal intelligence

> Type anything. zi figures out the rest.

zi is a zsh shell layer that lets you talk to your terminal in plain English. It routes your intent to the right tool automatically — whether that means generating a shell command, fixing an error, editing code, or running an autonomous agent.

```
zi why is my docker container crashing
zi add input validation to server.js
zi write a script to back up my dotfiles
zi what does git rebase -i actually do
```

Powered by [Groq](https://console.groq.com) (free tier, ~300ms) for quick queries, and optionally [Claude Code](https://claude.ai/code) for complex coding tasks.

---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/marcosrrez/zi/main/install.sh | bash
```

Then restart your shell and run the setup wizard:

```bash
zi setup
```

The wizard takes about 2 minutes. It configures your API key, detects your workflow, and walks you through installing the modern terminal tools that make zi (and your daily work) faster.

**Requirements:** zsh, curl, python3, fzf

---

## Ctrl+Space — the headline feature

Type any command, even a wrong one. Press **Ctrl+Space**. zi rewrites it in-place before you hit Enter.

```
gti status          →  git status
docker ps -all      →  docker ps -a
npm run start dev   →  npm run dev
```

It reads your intent, not just your spelling. No Enter required — the corrected command lands in your buffer so you can review it first.

---

## What zi does

| Command | What happens |
|---|---|
| `zi` | fzf command palette — 30+ commands, searchable |
| `zi <anything>` | Smart routing — zi figures out what you mean |
| `zi ask <q>` | Natural language → shell command |
| `zi fix` | Explain and fix your last error |
| `zi desc <cmd>` | Plain-English explanation of any command |
| `zi code <task>` | Generate code (Claude CLI if available, else Groq) |
| `zi edit <task>` | Claude edits your files autonomously (prompts before bash) |
| `zi agent <task>` | Claude fully autonomous — edits files and runs commands |
| `zi man <cmd>` | 10-bullet practical man page summary |
| `zi ? <text>` | Explain terminal output |
| `zi explain <file>` | Explain what a file does |
| `zi run <cmd>` | Run a command and copy output to clipboard |
| `zi log [filter]` | Browse recent zi queries |
| `zi chat [session]` | Persistent multi-turn conversation with context |
| `zi watch on\|off` | Auto-run `zi fix` whenever a command fails |
| `zi update` | Update zi to the latest version |
| `zi uninstall` | Remove zi from this machine |
| `Ctrl+Space` | AI-correct the current command buffer in-place |

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

zi has three levels of coding assistance:

**`zi code`** — generates code and prints it. No files are touched.

**`zi edit`** — Claude reads your codebase and edits files directly (`acceptEdits` mode). It will ask before running any shell commands. Shows a diff when done.

**`zi agent`** — fully autonomous. Claude edits files and runs commands without prompting. Requires confirmation to start. Shows a diff when done.

> `zi edit` and `zi agent` require [Claude Code](https://claude.ai/code) to be installed.

---

## Setup wizard

Running `zi setup` walks you through five steps:

1. **Experience level** — beginner mode adds explanations throughout
2. **Groq API key** — free at [console.groq.com](https://console.groq.com), saved to `~/.zshrc`
3. **Your workflow** — web, backend, devops, data, or general
4. **Terminal tools** — zi shows you what's missing across three tiers and offers to install:
   - **Essential** — fzf (required for the palette)
   - **Recommended** — fd, rg, bat, eza (faster versions of standard tools)
   - **Power tools** — zoxide, lazygit, atuin, dust, btm
5. **Personalized palette** — generates workflow-specific entries for the command palette

You can re-run `zi setup` any time to change your config.

---

## Configuration

| Variable | Default | Description |
|---|---|---|
| `GROQ_API_KEY` | — | Groq API key |
| `ZI_GROQ_KEY` | — | Alternative key variable |
| `ZI_MODEL` | `llama-3.3-70b-versatile` | Groq model to use |
| `ZI_CLAUDE` | auto-detected | Path to claude binary |

### Custom palette entries

Create `~/.config/zi/palette` with entries in `category|command|description` format:

```
work    |ssh deploy@prod               |SSH into production
db      |psql -U postgres mydb         |Connect to local Postgres
k8s     |kubectl get pods -A           |List all pods
```

These are appended to zi's built-in palette.

---

## How it works

zi is a single zsh script with no runtime dependencies beyond what you already have. It:

1. Detects which tools are installed on your machine and injects them as context into every prompt
2. Uses Groq's API for fast, free inference on quick queries (~300ms)
3. Shells out to Claude Code's CLI for tasks that need real coding power
4. Integrates with your shell natively — ZLE widget for Ctrl+Space, precmd hook for `zi watch`, fzf for the palette
5. Logs everything to `~/.local/share/zi/history.jsonl`

---

## Uninstall

```bash
zi uninstall
```

Removes the binary, config dir, session data, and the source line from `~/.zshrc`.

---

## License

MIT — see [LICENSE](LICENSE)
