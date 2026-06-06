#!/usr/bin/env bash
# install/gemini-cli.sh — Install and set up Gemini CLI
set -euo pipefail

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'

echo ""
echo -e "${CYAN}${BOLD}═══════════════════════════════════════${RESET}"
echo -e "${CYAN}${BOLD}   Installing Gemini CLI                ${RESET}"
echo -e "${CYAN}${BOLD}═══════════════════════════════════════${RESET}"
echo ""

# ─── Check for Node.js ───────────────────────────────────────────────────────
if ! command -v node &>/dev/null; then
  echo -e "${RED}✖ Node.js is required but not installed.${RESET}"
  echo "Install from https://nodejs.org (v18 or higher required)"
  exit 1
fi

node_version=$(node --version | sed 's/^v//' | cut -d. -f1)
if ! [[ "$node_version" =~ ^[0-9]+$ ]]; then
  echo -e "${RED}✖ Could not determine Node.js version. Install Node.js v18 or higher.${RESET}"
  exit 1
fi
if (( node_version < 18 )); then
  echo -e "${YELLOW}⚠ Node.js v${node_version} found. Gemini CLI requires v18+.${RESET}"
  exit 1
fi
echo -e "${GREEN}✔ Node.js $(node --version) detected${RESET}"

# ─── Install Gemini CLI ───────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}Installing Gemini CLI via npm...${RESET}"
npm install -g @google/gemini-cli

if command -v gemini &>/dev/null; then
  echo -e "${GREEN}✔ Gemini CLI installed: $(gemini --version 2>/dev/null || echo 'ok')${RESET}"
else
  echo -e "${YELLOW}⚠ 'gemini' not found in PATH. Restart your terminal and try again.${RESET}"
fi

# ─── API Key Setup ────────────────────────────────────────────────────────────
echo ""
echo -e "${YELLOW}⚠ A Google API key is required to use Gemini CLI.${RESET}"
echo ""
echo "  1. Visit https://aistudio.google.com/apikey"
echo "  2. Create a new API key"
echo "  3. Add it to your shell profile:"
echo ""
echo "     echo 'export GEMINI_API_KEY=\"your-key-here\"' >> ~/.zshrc"
echo "     source ~/.zshrc"
echo ""

# ─── Agent Config Setup ───────────────────────────────────────────────────────
echo -e "${BOLD}Setting up Gemini agents directory...${RESET}"
mkdir -p ~/.gemini/agents
echo -e "${GREEN}✔ Created ~/.gemini/agents/${RESET}"

echo ""
echo -e "${CYAN}${BOLD}Next Steps:${RESET}"
echo "  1. Set your GEMINI_API_KEY as shown above"
echo "  2. Copy your agent file to ~/.gemini/agents/"
echo "  3. Run: gemini --context ~/.gemini/agents/your-agent.md"
echo "  4. Docs: https://github.com/google-gemini/gemini-cli"
echo ""
