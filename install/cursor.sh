#!/usr/bin/env bash
# install/cursor.sh — Install and set up Cursor
set -euo pipefail

CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'

echo ""
echo -e "${CYAN}${BOLD}═══════════════════════════════════════${RESET}"
echo -e "${CYAN}${BOLD}   Installing Cursor                    ${RESET}"
echo -e "${CYAN}${BOLD}═══════════════════════════════════════${RESET}"
echo ""

OS="$(uname -s)"

# ─── Platform-specific install ────────────────────────────────────────────────
case "$OS" in
  Darwin)
    if command -v brew &>/dev/null; then
      echo -e "${BOLD}Installing Cursor via Homebrew...${RESET}"
      brew install --cask cursor
      echo -e "${GREEN}✔ Cursor installed via Homebrew${RESET}"
    else
      echo -e "${YELLOW}⚠ Homebrew not found. Download Cursor manually:${RESET}"
      echo "  https://cursor.sh"
      echo ""
      echo "Or install Homebrew first:"
      echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    fi
    ;;
  Linux)
    echo -e "${YELLOW}On Linux, download the AppImage from:${RESET}"
    echo "  https://cursor.sh"
    echo ""
    echo "Then make it executable and run:"
    echo "  chmod +x cursor-*.AppImage"
    echo "  ./cursor-*.AppImage"
    ;;
  MINGW*|CYGWIN*|MSYS*)
    echo -e "${YELLOW}On Windows, download the installer from:${RESET}"
    echo "  https://cursor.sh"
    ;;
  *)
    echo -e "${RED}Unsupported OS: ${OS}${RESET}"
    echo "Visit https://cursor.sh to download manually."
    ;;
esac

# ─── Agent/Rules Setup ────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}Setting up Cursor rules directory...${RESET}"
mkdir -p .cursor/rules
echo -e "${GREEN}✔ Created .cursor/rules/${RESET}"

echo ""
echo -e "${CYAN}${BOLD}Next Steps:${RESET}"
echo "  1. Open Cursor and sign in"
echo "  2. Copy your agent file to .cursor/rules/"
echo "  3. Open Cursor Settings → Rules to activate it"
echo "  4. Use Ctrl+L / Cmd+L to open AI chat, then mention your agent"
echo "  5. Docs: https://docs.cursor.com"
echo ""
