#!/usr/bin/env bash
# install/devin.sh — Set up Devin (web-based, no local install required)
set -euo pipefail

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BOLD='\033[1m'; RESET='\033[0m'

echo ""
echo -e "${CYAN}${BOLD}═══════════════════════════════════════${RESET}"
echo -e "${CYAN}${BOLD}   Setting up for Devin                 ${RESET}"
echo -e "${CYAN}${BOLD}═══════════════════════════════════════${RESET}"
echo ""

echo -e "${YELLOW}Devin is a cloud-based agent — no local installation required.${RESET}"
echo ""
echo "To use your agent with Devin:"
echo ""
echo "  1. Sign up or log in at https://devin.ai"
echo "  2. Create a new session"
echo "  3. In session settings, paste the content of your agent .md file"
echo "     as the system prompt or initial context"
echo "  4. Alternatively, add your agent file to the workspace repo"
echo "     and reference it in your session instructions"
echo ""

# ─── Copy agent file hint ─────────────────────────────────────────────────────
if ls ./*.md 1>/dev/null 2>&1; then
  echo -e "${GREEN}Agent files found in current directory:${RESET}"
  ls ./*.md
  echo ""
  echo "Copy the content of your agent file and paste it into the Devin session."
fi

echo -e "${CYAN}${BOLD}Resources:${RESET}"
echo "  • Devin Docs: https://docs.devin.ai"
echo "  • Session configuration: https://docs.devin.ai/get-started/quickstart"
echo ""
