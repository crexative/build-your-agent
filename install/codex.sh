#!/usr/bin/env bash
# install/codex.sh — Install and set up OpenAI Codex CLI
set -euo pipefail

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'

echo ""
echo -e "${CYAN}${BOLD}═══════════════════════════════════════${RESET}"
echo -e "${CYAN}${BOLD}   Installing OpenAI Codex CLI          ${RESET}"
echo -e "${CYAN}${BOLD}═══════════════════════════════════════${RESET}"
echo ""

# ─── Check for Node.js ───────────────────────────────────────────────────────
if ! command -v node &>/dev/null; then
  echo -e "${RED}✖ Node.js is required but not installed.${RESET}"
  echo "Install from https://nodejs.org (v22 or higher recommended)"
  exit 1
fi
echo -e "${GREEN}✔ Node.js $(node --version) detected${RESET}"

# ─── Install Codex CLI ────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}Installing OpenAI Codex CLI via npm...${RESET}"
npm install -g @openai/codex

if command -v codex &>/dev/null; then
  echo -e "${GREEN}✔ Codex CLI installed: $(codex --version 2>/dev/null || echo 'ok')${RESET}"
else
  echo -e "${YELLOW}⚠ 'codex' not found in PATH. Restart your terminal.${RESET}"
fi

# ─── API Key Setup ────────────────────────────────────────────────────────────
echo ""
echo -e "${YELLOW}⚠ An OpenAI API key is required.${RESET}"
echo ""
echo "  1. Visit https://platform.openai.com/api-keys"
echo "  2. Create a new secret key"
echo "  3. Add it to your shell profile:"
echo ""
echo "     echo 'export OPENAI_API_KEY=\"your-key-here\"' >> ~/.zshrc"
echo "     source ~/.zshrc"
echo ""

# ─── Agent Config Setup ───────────────────────────────────────────────────────
echo -e "${BOLD}Setting up Codex agents directory...${RESET}"
mkdir -p ~/.codex/agents
echo -e "${GREEN}✔ Created ~/.codex/agents/${RESET}"

echo ""
echo -e "${CYAN}${BOLD}Next Steps:${RESET}"
echo "  1. Set your OPENAI_API_KEY as shown above"
echo "  2. Copy your agent file to ~/.codex/agents/"
echo "  3. Run: codex --approval-mode full-auto"
echo "  4. Use the content of your agent as the system prompt in the session"
echo "  5. Docs: https://github.com/openai/codex"
echo ""
