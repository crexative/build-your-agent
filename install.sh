#!/usr/bin/env bash
# install.sh — Download and run the Build Your Agent interactive guide
# Usage: curl -fsSL https://raw.githubusercontent.com/crexative/build-your-agent/main/install.sh | bash
set -euo pipefail

REPO="https://raw.githubusercontent.com/crexative/build-your-agent/main"
SCRIPT="create-agent.sh"
TMP="$(mktemp -t build-your-agent.XXXXXX)"
trap 'rm -f "$TMP"' EXIT INT TERM

if [[ -t 1 && "${NO_COLOR:-}" == "" && "${TERM:-}" != "dumb" ]]; then
  CYAN='\033[0;36m'; GREEN='\033[0;32m'; RED='\033[0;31m'; BOLD='\033[1m'; RESET='\033[0m'
else
  CYAN=''; GREEN=''; RED=''; BOLD=''; RESET=''
fi

echo ""
echo -e "${CYAN}${BOLD}╔════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}${BOLD}║        🤖  BUILD YOUR AGENT  🤖            ║${RESET}"
echo -e "${CYAN}${BOLD}╚════════════════════════════════════════════╝${RESET}"
echo ""

# ─── Download ────────────────────────────────────────────────────────────────
if command -v curl &>/dev/null; then
  curl -fsSL "${REPO}/${SCRIPT}" -o "$TMP"
elif command -v wget &>/dev/null; then
  wget -qO "$TMP" "${REPO}/${SCRIPT}"
else
  echo -e "${RED}✖ curl or wget is required. Install one and retry.${RESET}"
  exit 1
fi

echo -e "${GREEN}✔ Downloaded ${SCRIPT}${RESET}"
echo ""

# ─── Run ─────────────────────────────────────────────────────────────────────
bash "$TMP" < /dev/tty

# Cleanup is handled by the EXIT trap registered above.
