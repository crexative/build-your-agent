Output docs/demo.gif

Set Shell bash
Set Width 1200
Set Height 700
Set FontSize 16
Set Theme "Dracula"
Set Padding 20
Set TypingSpeed 40ms

# ── Launch ────────────────────────────────────────────────────────────────────
Type "cd /Users/erixmendoza/Documents/build-your-agent && BYA_DEMO=1 ./create-agent.sh"
Enter
Sleep 3s

# ── Step 0: Language → English ────────────────────────────────────────────────
Type "1"
Enter
Sleep 2s

# ── Step 1: Identity ──────────────────────────────────────────────────────────
# Agent name
Type "code-reviewer"
Enter
Sleep 800ms

# Description
Type "Expert code reviewer. Use PROACTIVELY after writing or modifying code."
Enter
Sleep 800ms

# Objective
Type "Review code for bugs, security issues, and best practices"
Enter
Sleep 1200ms

# Role → Specialist
Type "3"
Enter
Sleep 1200ms

# ── Step 2: Platform → Claude Code ───────────────────────────────────────────
Type "1"
Enter
Sleep 1s

# ── Step 3: Model → Sonnet, Color → purple ───────────────────────────────────
Type "1"
Enter
Sleep 800ms

Type "6"
Enter
Sleep 1200ms

# ── Step 4: Tools → Read, Edit, Grep ─────────────────────────────────────────
Type "1 3 6"
Enter
Sleep 800ms

# MCP → No (Enter = default N)
Enter
Sleep 1200ms

# ── Step 5: Behavior + Constraints ───────────────────────────────────────────
Type "meticulous and detail-oriented"
Enter
Sleep 800ms

Type "Auto-approve changes without explicit user confirmation"
Enter
Sleep 1200ms

# ── Step 6: Filename → use default (Enter) ───────────────────────────────────
Enter
Sleep 800ms

# Where to install → 1 (Global)
Type "1"
Enter
Sleep 2s

# Install platform script → No (Enter = default N)
Enter
Sleep 3s
