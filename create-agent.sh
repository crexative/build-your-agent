#!/usr/bin/env bash
# create-agent.sh — Interactive guide to create your first AI agent
# Compatible with: Claude Code, Cursor, Devin, Windsurf, Gemini CLI, OpenAI Codex, Aider
set -euo pipefail

# ─── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ─── Helpers ──────────────────────────────────────────────────────────────────
print_header() {
  echo ""
  echo -e "${CYAN}${BOLD}╔══════════════════════════════════════════════════════╗${RESET}"
  echo -e "${CYAN}${BOLD}║           🤖  BUILD YOUR AGENT  🤖                  ║${RESET}"
  echo -e "${CYAN}${BOLD}╚══════════════════════════════════════════════════════╝${RESET}"
  echo ""
}

print_step() {
  echo ""
  echo -e "${BLUE}${BOLD}▶ $1${RESET}"
}

print_success() {
  echo -e "${GREEN}✔ $1${RESET}"
}

print_warning() {
  echo -e "${YELLOW}⚠ $1${RESET}"
}

print_error() {
  echo -e "${RED}✖ $1${RESET}"
}

ask() {
  # ask <variable_name> <prompt>
  local var_name="$1"
  local prompt="$2"
  echo -ne "${BOLD}${prompt}${RESET} "
  read -r "$var_name"
}

ask_choice() {
  # ask_choice <variable_name> <prompt> <option1> <option2> ...
  local var_name="$1"
  local prompt="$2"
  shift 2
  local options=("$@")
  local num="${#options[@]}"

  echo -e "${BOLD}${prompt}${RESET}"
  for i in "${!options[@]}"; do
    echo -e "  ${CYAN}$((i+1))${RESET}) ${options[$i]}"
  done

  while true; do
    echo -ne "${BOLD}Choose [1-${num}]: ${RESET}"
    read -r choice
    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= num )); then
      eval "$var_name=\"${options[$((choice-1))]}\""
      break
    fi
    echo -e "${RED}Invalid choice. Enter a number between 1 and ${num}.${RESET}"
  done
}

ask_multiselect() {
  # ask_multiselect <result_var> <prompt> <option1> <option2> ...
  # Returns comma-separated selected values in result_var
  local var_name="$1"
  local prompt="$2"
  shift 2
  local options=("$@")
  local num="${#options[@]}"
  local selected=()

  echo -e "${BOLD}${prompt}${RESET}"
  echo -e "${YELLOW}(Enter numbers separated by spaces, e.g.: 1 3 5)${RESET}"
  for i in "${!options[@]}"; do
    echo -e "  ${CYAN}$((i+1))${RESET}) ${options[$i]}"
  done

  while true; do
    echo -ne "${BOLD}Select tools [1-${num}]: ${RESET}"
    read -r -a choices
    local valid=true
    selected=()
    for c in "${choices[@]}"; do
      if [[ "$c" =~ ^[0-9]+$ ]] && (( c >= 1 && c <= num )); then
        selected+=("${options[$((c-1))]}")
      else
        valid=false
        break
      fi
    done
    if [[ "$valid" == true ]] && (( ${#selected[@]} > 0 )); then
      local joined
      joined=$(IFS=', '; echo "${selected[*]}")
      eval "$var_name=\"$joined\""
      break
    fi
    echo -e "${RED}Invalid selection. Please enter valid numbers between 1 and ${num}.${RESET}"
  done
}

confirm() {
  # confirm <prompt> — returns 0 for yes, 1 for no
  echo -ne "${BOLD}$1 [y/N]: ${RESET}"
  read -r answer
  [[ "$answer" =~ ^[Yy]$ ]]
}

# ─── Language Selection ───────────────────────────────────────────────────────
select_language() {
  print_step "Language / Idioma"
  echo ""
  echo -e "  ${CYAN}1${RESET}) English"
  echo -e "  ${CYAN}2${RESET}) Español"
  echo ""
  while true; do
    echo -ne "${BOLD}Choose / Elige [1-2]: ${RESET}"
    read -r lang_choice
    case "$lang_choice" in
      1) LANG_CODE="en"; break ;;
      2) LANG_CODE="es"; break ;;
      *) echo -e "${RED}Please enter 1 or 2.${RESET}" ;;
    esac
  done
}

# ─── Strings (i18n) ───────────────────────────────────────────────────────────
load_strings() {
  if [[ "$LANG_CODE" == "es" ]]; then
    MSG_WELCOME="¡Bienvenido/a! Vamos a crear tu primer agente de IA."
    MSG_AGENT_NAME="Nombre de tu agente (ej: mi-asistente):"
    MSG_AGENT_DESC="¿Qué hace tu agente? (descripción corta):"
    MSG_AGENT_OBJ="¿Cuál es su objetivo principal?"
    MSG_TOOLS="¿Qué herramientas puede usar tu agente?"
    MSG_PLATFORM="¿En qué plataforma quieres desplegarlo?"
    MSG_BEHAVIOR="¿Cómo debe comportarse? (ej: profesional, amigable, conciso):"
    MSG_CONSTRAINTS="¿Qué NO debe hacer? (ej: no acceder a internet, no ejecutar código):"
    MSG_OUTPUT_FILE="Nombre del archivo de salida (sin extensión, ej: mi-agente):"
    MSG_GENERATING="Generando tu agente..."
    MSG_GENERATED="¡Agente creado exitosamente!"
    MSG_INSTALL_PROMPT="¿Quieres instalar la herramienta seleccionada ahora?"
    MSG_DONE="¡Listo! Tu agente está en:"
    MSG_NEXT_STEPS="Próximos pasos:"
    MSG_STEP1="1. Revisa el archivo generado"
    MSG_STEP2="2. Personaliza según tus necesidades"
    MSG_STEP3="3. Sigue las instrucciones de tu plataforma"
    MSG_INVALID="Opción inválida."
    MSG_THANKS="¡Gracias por usar Build Your Agent!"
  else
    MSG_WELCOME="Welcome! Let's create your first AI agent."
    MSG_AGENT_NAME="Agent name (e.g. my-assistant):"
    MSG_AGENT_DESC="What does your agent do? (short description):"
    MSG_AGENT_OBJ="What is its main objective?"
    MSG_TOOLS="What tools can your agent use?"
    MSG_PLATFORM="Which platform are you targeting?"
    MSG_BEHAVIOR="How should it behave? (e.g. professional, friendly, concise):"
    MSG_CONSTRAINTS="What should it NOT do? (e.g. no internet access, no code execution):"
    MSG_OUTPUT_FILE="Output filename (no extension, e.g. my-agent):"
    MSG_GENERATING="Generating your agent..."
    MSG_GENERATED="Agent created successfully!"
    MSG_INSTALL_PROMPT="Do you want to install the selected platform now?"
    MSG_DONE="Done! Your agent file is at:"
    MSG_NEXT_STEPS="Next steps:"
    MSG_STEP1="1. Review the generated file"
    MSG_STEP2="2. Customize it to your needs"
    MSG_STEP3="3. Follow your platform's instructions"
    MSG_INVALID="Invalid option."
    MSG_THANKS="Thanks for using Build Your Agent!"
  fi
}

# ─── Gather Agent Info ────────────────────────────────────────────────────────
gather_agent_info() {
  echo ""
  echo -e "${GREEN}${MSG_WELCOME}${RESET}"
  echo ""

  print_step "${MSG_AGENT_NAME}"
  ask agent_name "${MSG_AGENT_NAME}"
  # Sanitize: lowercase, replace spaces with hyphens
  agent_name=$(echo "$agent_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-_')

  print_step "${MSG_AGENT_DESC}"
  ask agent_description "${MSG_AGENT_DESC}"

  print_step "${MSG_AGENT_OBJ}"
  ask agent_objective "${MSG_AGENT_OBJ}"

  print_step "${MSG_TOOLS}"
  local tool_options=(
    "Read files"
    "Write files"
    "Execute shell commands"
    "Search the web"
    "Call external APIs"
    "Read and write databases"
    "Manage Git repositories"
    "Analyze images"
    "Send emails/messages"
    "Custom tool (describe later)"
  )
  ask_multiselect agent_tools "${MSG_TOOLS}" "${tool_options[@]}"

  print_step "${MSG_BEHAVIOR}"
  ask agent_behavior "${MSG_BEHAVIOR}"

  print_step "${MSG_CONSTRAINTS}"
  ask agent_constraints "${MSG_CONSTRAINTS}"

  print_step "${MSG_PLATFORM}"
  local platform_options=(
    "Claude Code"
    "Cursor"
    "Devin"
    "Windsurf"
    "Gemini CLI"
    "OpenAI Codex"
    "Aider"
  )
  ask_choice agent_platform "${MSG_PLATFORM}" "${platform_options[@]}"

  print_step "${MSG_OUTPUT_FILE}"
  ask output_filename "${MSG_OUTPUT_FILE}"
  output_filename=$(echo "$output_filename" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-_')
  if [[ -z "$output_filename" ]]; then
    output_filename="$agent_name"
  fi
}

# ─── Platform-Specific Instructions ──────────────────────────────────────────
get_platform_instructions() {
  local platform="$1"
  case "$platform" in
    "Claude Code")
      if [[ "$LANG_CODE" == "es" ]]; then
        echo "Guarda este archivo como \`.claude/agents/${output_filename}.md\` en tu proyecto. Claude Code lo reconocerá automáticamente como agente disponible."
      else
        echo "Save this file as \`.claude/agents/${output_filename}.md\` in your project. Claude Code will automatically recognize it as an available agent."
      fi
      ;;
    "Cursor")
      if [[ "$LANG_CODE" == "es" ]]; then
        echo "Guarda este archivo como \`.cursor/agents/${output_filename}.md\` o referéncialo en la configuración de reglas de Cursor (.cursorrules)."
      else
        echo "Save this file as \`.cursor/agents/${output_filename}.md\` or reference it in your Cursor rules configuration (.cursorrules)."
      fi
      ;;
    "Devin")
      if [[ "$LANG_CODE" == "es" ]]; then
        echo "Sube este archivo a tu espacio de trabajo de Devin o úsalo como prompt del sistema en la configuración de tu sesión."
      else
        echo "Upload this file to your Devin workspace or use it as the system prompt in your session configuration."
      fi
      ;;
    "Windsurf")
      if [[ "$LANG_CODE" == "es" ]]; then
        echo "Guarda este archivo como \`.windsurf/agents/${output_filename}.md\` o agrégalo como instrucción global en la configuración de Windsurf."
      else
        echo "Save this file as \`.windsurf/agents/${output_filename}.md\` or add it as a global instruction in Windsurf settings."
      fi
      ;;
    "Gemini CLI")
      if [[ "$LANG_CODE" == "es" ]]; then
        echo "Usa este archivo como contexto con: \`gemini --context ${output_filename}.md\` o configúralo en \`~/.gemini/agents/${output_filename}.md\`."
      else
        echo "Use this file as context with: \`gemini --context ${output_filename}.md\` or configure it in \`~/.gemini/agents/${output_filename}.md\`."
      fi
      ;;
    "OpenAI Codex")
      if [[ "$LANG_CODE" == "es" ]]; then
        echo "Usa el contenido de este archivo como prompt del sistema al llamar a la API de Codex, o guárdalo en \`~/.codex/agents/${output_filename}.md\`."
      else
        echo "Use the content of this file as the system prompt when calling the Codex API, or save it in \`~/.codex/agents/${output_filename}.md\`."
      fi
      ;;
    "Aider")
      if [[ "$LANG_CODE" == "es" ]]; then
        echo "Usa este archivo con: \`aider --system-prompt ${output_filename}.md\` o agrégalo a tu configuración \`.aider.conf.yml\`."
      else
        echo "Use this file with: \`aider --system-prompt ${output_filename}.md\` or add it to your \`.aider.conf.yml\` configuration."
      fi
      ;;
    *)
      echo ""
      ;;
  esac
}

# ─── Generate Agent File ──────────────────────────────────────────────────────
generate_agent_file() {
  local output_path="${output_filename}.md"
  local platform_instructions
  platform_instructions=$(get_platform_instructions "$agent_platform")

  local today
  today=$(date +%Y-%m-%d 2>/dev/null || echo "unknown")

  cat > "$output_path" <<EOF
---
name: ${agent_name}
platform: ${agent_platform}
language: ${LANG_CODE}
created: ${today}
---

# Agent: ${agent_name}

## Description

${agent_description}

## Objective

${agent_objective}

## Available Tools

${agent_tools}

## Behavior

${agent_behavior}

## Constraints

${agent_constraints}

## Output Format

- Respond in clear, structured paragraphs or lists as appropriate
- Cite sources when using retrieved information
- Ask for clarification before taking irreversible actions
- Summarize completed actions at the end of each response

## Platform Instructions

**${agent_platform}**

${platform_instructions}

---

*Generated with [Build Your Agent](https://github.com/YOUR_USERNAME/build-your-agent)*
EOF

  print_success "${MSG_GENERATED}"
  echo ""
  echo -e "  ${BOLD}${MSG_DONE}${RESET} ${CYAN}${output_path}${RESET}"
}

# ─── Install Platform ─────────────────────────────────────────────────────────
run_install() {
  local platform="$agent_platform"
  local script_name=""

  case "$platform" in
    "Claude Code")   script_name="claude-code" ;;
    "Cursor")        script_name="cursor" ;;
    "Devin")         script_name="devin" ;;
    "Windsurf")      script_name="windsurf" ;;
    "Gemini CLI")    script_name="gemini-cli" ;;
    "OpenAI Codex")  script_name="codex" ;;
    "Aider")         script_name="aider" ;;
  esac

  local install_script
  install_script="$(dirname "$0")/install/${script_name}.sh"

  if [[ -f "$install_script" ]]; then
    echo ""
    print_step "Running install/${script_name}.sh ..."
    bash "$install_script"
  else
    print_warning "Install script not found: install/${script_name}.sh"
    echo "You can install manually by following the instructions in your agent file."
  fi
}

# ─── Post-generation Summary ──────────────────────────────────────────────────
show_summary() {
  echo ""
  echo -e "${CYAN}${BOLD}─────────────────────────────────────────────${RESET}"
  echo -e "${BOLD}${MSG_NEXT_STEPS}${RESET}"
  echo -e "  ${MSG_STEP1}"
  echo -e "  ${MSG_STEP2}"
  echo -e "  ${MSG_STEP3}"
  echo -e "${CYAN}${BOLD}─────────────────────────────────────────────${RESET}"
  echo ""
  echo -e "  ${GREEN}${BOLD}${MSG_THANKS}${RESET}"
  echo ""
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  print_header
  select_language
  load_strings
  gather_agent_info

  echo ""
  print_step "${MSG_GENERATING}"
  generate_agent_file

  if confirm "${MSG_INSTALL_PROMPT}"; then
    run_install
  fi

  show_summary
}

main "$@"
