# psy demo — record with: vhs demo.tape
# Install vhs: brew install vhs
# Output: demo.gif

Output demo.gif
Set Shell "zsh"
Set FontSize 14
Set Width 900
Set Height 550
Set Theme "Catppuccin Mocha"
Set Padding 20
Set TypingSpeed 80ms
Set PlaybackSpeed 1.0

# ── Intro ────────────────────────────────────────────────────────────────────
Sleep 1s
Type "# psy — terminal intelligence"
Sleep 2s
Ctrl+C

# ── 1. Ask: natural language to command ──────────────────────────────────────
Sleep 500ms
Type "psy find all files larger than 50MB in my home directory"
Sleep 1s
Enter
Sleep 3s

# ── 2. Fix: explain last error ────────────────────────────────────────────────
Sleep 500ms
Type "git push"
Enter
Sleep 2s
Type "psy fix"
Enter
Sleep 4s

# ── 3. Ctrl+Space: in-place correction ───────────────────────────────────────
Sleep 500ms
Type "# Ctrl+Space corrects commands in-place"
Sleep 1500ms
Ctrl+C
Sleep 300ms
Type "gti status"
Sleep 1s
Ctrl+Space
Sleep 2500ms

# ── 4. desc: explain a command ───────────────────────────────────────────────
Sleep 500ms
Type "psy desc git rebase -i HEAD~3"
Enter
Sleep 4s

# ── 5. Palette ───────────────────────────────────────────────────────────────
Sleep 500ms
Type "# Press Enter to open the command palette"
Sleep 1500ms
Ctrl+C
Sleep 300ms
Type "psy"
Enter
Sleep 2s
Type "docker"
Sleep 1500ms
Escape

Sleep 1s
