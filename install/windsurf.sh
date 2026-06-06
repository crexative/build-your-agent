#!/usr/bin/env bash
# install/windsurf.sh — Install and set up Windsurf by Codeium
set -euo pipefail

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'

echo ""
echo -e "${CYAN}${BOLD}═══════════════════════════════════════${RESET}"
echo -e "${CYAN}${BOLD}   Installing Windsurf                  ${RESET}"
echo -e "${CYAN}${BOLD}═══════════════════════════════════════${RESET}"
echo ""

OS="$(uname -s)"

case "$OS" in
  Darwin)
    if command -v brew &>/dev/null; then
      echo -e "${BOLD}Installing Windsurf via Homebrew...${RESET}"
      brew install --cask windsurf
      echo -e "${GREEN}✔ Windsurf installed via Homebrew${RESET}"
    else
      echo -e "${YELLOW}Download Windsurf from:${RESET}"
      echo "  https://codeium.com/windsurf/download"
    fi
    ;;
  Linux)
    echo -e "${YELLOW}Download the Linux package from:${RESET}"
    echo "  https://codeium.com/windsurf/download"
    ;;
  MINGW*|CYGWIN*|MSYS*)
    echo -e "${YELLOW}Download the Windows installer from:${RESET}"
    echo "  https://codeium.com/windsurf/download"
    ;;
  *)
    echo -e "${RED}Unsupported OS: ${OS}${RESET}"
    echo "Visit https://codeium.com/windsurf/download"
    ;;
esac

# ─── Windsurf Rules Setup ─────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}Setting up Windsurf rules directory...${RESET}"
mkdir -p .windsurf/rules
echo -e "${GREEN}✔ Created .windsurf/rules/${RESET}"

echo ""
echo -e "${CYAN}${BOLD}Next Steps:${RESET}"
echo "  1. Open Windsurf and sign in with Codeium"
echo "  2. Copy your agent .md file to .windsurf/rules/"
echo "  3. Open Windsurf Settings → Cascade → Global Rules to paste your agent"
echo "  4. Use Cmd+L / Ctrl+L to open Cascade AI and mention your agent"
echo "  5. Docs: https://docs.codeium.com/windsurf"
echo ""
