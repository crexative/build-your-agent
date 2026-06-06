#!/usr/bin/env bash
# install/claude-code.sh — Install and set up Claude Code
set -euo pipefail

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'

echo ""
echo -e "${CYAN}${BOLD}═══════════════════════════════════════${RESET}"
echo -e "${CYAN}${BOLD}   Installing Claude Code               ${RESET}"
echo -e "${CYAN}${BOLD}═══════════════════════════════════════${RESET}"
echo ""

# ─── Check for Node.js ───────────────────────────────────────────────────────
if ! command -v node &>/dev/null; then
  echo -e "${RED}✖ Node.js is required but not installed.${RESET}"
  echo ""
  echo "Install Node.js (v18 or higher):"
  echo "  • macOS/Linux: https://nodejs.org or via nvm:"
  echo "      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash"
  echo "      nvm install --lts"
  echo "  • Windows: https://nodejs.org"
  exit 1
fi

node_version=$(node --version | tr -d 'v' | cut -d. -f1)
if (( node_version < 18 )); then
  echo -e "${YELLOW}⚠ Node.js v${node_version} detected. Claude Code requires v18+.${RESET}"
  echo "Upgrade with: nvm install --lts"
  exit 1
fi
echo -e "${GREEN}✔ Node.js $(node --version) detected${RESET}"

# ─── Install Claude Code ──────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}Installing Claude Code via npm...${RESET}"
npm install -g @anthropic-ai/claude-code

echo ""
echo -e "${GREEN}✔ Claude Code installed successfully!${RESET}"

# ─── Verify Installation ──────────────────────────────────────────────────────
if command -v claude &>/dev/null; then
  echo -e "${GREEN}✔ 'claude' command is available${RESET}"
  echo "   Version: $(claude --version 2>/dev/null || echo 'unknown')"
else
  echo -e "${YELLOW}⚠ 'claude' not found in PATH. You may need to restart your terminal.${RESET}"
fi

# ─── Agent Directory Setup ────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}Setting up agents directory in current project...${RESET}"
mkdir -p .claude/agents
echo -e "${GREEN}✔ Created .claude/agents/${RESET}"

echo ""
echo -e "${CYAN}${BOLD}Next Steps:${RESET}"
echo "  1. Run 'claude' in any project directory to start"
echo "  2. Copy your generated agent file to .claude/agents/"
echo "  3. Use /agents in Claude Code to list available agents"
echo "  4. Full docs: https://docs.anthropic.com/en/docs/claude-code"
echo ""
