# Contributing to zi

Thanks for your interest in improving zi.

## What makes a good contribution

zi is intentionally minimal — a single shell script with no runtime dependencies beyond zsh, curl, and python3. Before contributing, ask: does this add real value without adding complexity or dependencies?

Good contributions:
- Bug fixes with a clear reproduction case
- New palette entries that are broadly useful (not personal/opinionated)
- Improvements to the setup wizard for new platforms or tools
- Better intent routing heuristics
- Documentation improvements

Things that need discussion first (open an issue):
- New subcommands
- Changes to the Groq integration or adding new AI backends
- Changes to zi.zsh that affect shell startup time

## Setup

```bash
git clone https://github.com/marcosrrez/zi
cd zi
# Make the binary executable
chmod +x zi
# Test it directly
./zi help
./zi ask "list all git repos in current directory"
```

## Adding palette entries

The default palette lives in `_zi_default_entries()` inside the `zi` binary. Entries use this format:

```
category|command                       |description
```

- Category is shown in the fzf prompt for grouping
- Command should work on a standard macOS or Linux system
- Avoid commands that require personal configuration (custom aliases, specific paths)
- If a command requires a specific tool, check it's in the `_zi_detect_tools` candidates list

## Improving intent routing

The `_zi_route()` function uses grep-based heuristics to classify plain text input. If you find a case that routes incorrectly, open an issue with:

1. The input you typed
2. Which mode it routed to
3. Which mode you expected

Routing improvements should be conservative — prefer false negatives (falls through to `ask`) over false positives (routes to the wrong mode).

## Platform support

zi is tested on macOS (zsh). Linux support is best-effort. Windows/WSL contributions are welcome but please include a test case.

If you're adding Linux-specific behavior, guard it with `[[ "$(uname -s)" == "Linux" ]]`.

## Submitting a PR

1. Fork the repo and create a branch
2. Make your change
3. Test it manually — run `./zi setup` and the affected subcommands
4. Open a PR with a clear description of what it changes and why

There are no automated tests yet. Manual testing is expected.

## Reporting bugs

Open an issue with:
- Your OS and zsh version (`zsh --version`)
- The zi version (`zi version`)
- The exact command you ran
- What you expected vs. what happened
