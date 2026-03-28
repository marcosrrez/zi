# psy — terminal intelligence

> Type anything. psy figures out the rest.

psy is a zsh shell layer that lets you talk to your terminal in plain English. It routes your intent to the right tool automatically — whether that means generating a shell command, fixing an error, editing code, or running an autonomous agent.

```
psy why is my docker container crashing
psy add input validation to server.js
psy write a script to back up my dotfiles
psy what does git rebase -i actually do
```

Powered by [Groq](https://console.groq.com) (free tier, ~300ms) for quick queries, and optionally [Claude Code](https://claude.ai/code) for complex coding tasks.

---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/marcosrrez/psy/main/install.sh | bash
```

Then restart your shell and run the setup wizard:

```bash
psy setup
```

The wizard takes about 2 minutes. It configures your API key, detects your workflow, and walks you through installing the modern terminal tools that make psy (and your daily work) faster.

**Requirements:** zsh, curl, python3, fzf

> **zinit/zoxide users:** no conflict — both tools use `zi`, not `psy`.

---

## Ctrl+Space — the headline feature

Type any command, even a wrong one. Press **Ctrl+Space**. psy rewrites it in-place before you hit Enter.

```
gti status          →  git status
docker ps -all      →  docker ps -a
npm run start dev   →  npm run dev
```

It reads your intent, not just your spelling. No Enter required — the corrected command lands in your buffer so you can review it first.

---

## What psy does

| Command | What happens |
|---|---|
| `psy` | fzf command palette — 30+ commands, searchable |
| `psy <anything>` | Smart routing — psy figures out what you mean |
| `psy ask <q>` | Natural language → shell command |
| `psy fix` | Explain and fix your last error |
| `psy desc <cmd>` | Plain-English explanation of any command |
| `psy code <task>` | Generate code (Claude CLI if available, else Groq) |
| `psy edit <task>` | Claude edits your files autonomously (prompts before bash) |
| `psy agent <task>` | Claude fully autonomous — edits files and runs commands |
| `psy man <cmd>` | 10-bullet practical man page summary |
| `psy ? <text>` | Explain terminal output |
| `psy explain <file>` | Explain what a file does |
| `psy run <cmd>` | Run a command and copy output to clipboard |
| `psy log [filter]` | Browse recent psy queries |
| `psy chat [session]` | Persistent multi-turn conversation with context |
| `psy watch on\|off` | Auto-run `psy fix` whenever a command fails |
| `psy update` | Update psy to the latest version |
| `psy uninstall` | Remove psy from this machine |
| `Ctrl+Space` | AI-correct the current command buffer in-place |

---

## Intent routing

When you type `psy <anything>` without a subcommand, psy classifies your intent automatically:

| What you type | Routes to |
|---|---|
| A file path that exists | `psy explain` |
| "why did my build fail" | `psy fix` |
| "what does git rebase -i do" | `psy desc` |
| `git log --oneline` (bare command) | `psy desc` |
| "add error handling to server.js" | `psy edit` |
| "write a script to backup my files" | `psy code` |
| Anything else | `psy ask` |

---

## Coding modes

psy has three levels of coding assistance:

**`psy code`** — generates code and prints it. No files are touched.

**`psy edit`** — Claude reads your codebase and edits files directly (`acceptEdits` mode). It will ask before running any shell commands. Shows a diff when done.

**`psy agent`** — fully autonomous. Claude edits files and runs commands without prompting. Requires confirmation to start. Shows a diff when done.

> `psy edit` and `psy agent` require [Claude Code](https://claude.ai/code) to be installed.

---

## Setup wizard

Running `psy setup` walks you through five steps:

1. **Experience level** — beginner mode adds explanations throughout
2. **Groq API key** — free at [console.groq.com](https://console.groq.com), saved to `~/.zshrc`
3. **Your workflow** — web, backend, devops, data, or general
4. **Terminal tools** — psy shows you what's missing across three tiers and offers to install:
   - **Essential** — fzf (required for the palette)
   - **Recommended** — fd, rg, bat, eza (faster versions of standard tools)
   - **Power tools** — zoxide, lazygit, atuin, dust, btm
5. **Personalized palette** — generates workflow-specific entries for the command palette

You can re-run `psy setup` any time to change your config.

---

## Configuration

| Variable | Default | Description |
|---|---|---|
| `GROQ_API_KEY` | — | Groq API key |
| `PSY_GROQ_KEY` | — | Alternative key variable |
| `PSY_MODEL` | `llama-3.3-70b-versatile` | Groq model to use |
| `PSY_CLAUDE` | auto-detected | Path to claude binary |

### Custom palette entries

Create `~/.config/psy/palette` with entries in `category|command|description` format:

```
work    |ssh deploy@prod               |SSH into production
db      |psql -U postgres mydb         |Connect to local Postgres
k8s     |kubectl get pods -A           |List all pods
```

These are appended to psy's built-in palette.

---

## How it works

psy is a single zsh script with no runtime dependencies beyond what you already have. It:

1. Detects which tools are installed on your machine and injects them as context into every prompt
2. Uses Groq's API for fast, free inference on quick queries (~300ms)
3. Shells out to Claude Code's CLI for tasks that need real coding power
4. Integrates with your shell natively — ZLE widget for Ctrl+Space, precmd hook for `psy watch`, fzf for the palette
5. Logs everything to `~/.local/share/psy/history.jsonl`

---

## Uninstall

```bash
psy uninstall
```

Removes the binary, config dir, session data, and the source line from `~/.zshrc`.

---

## License

MIT — see [LICENSE](LICENSE)
