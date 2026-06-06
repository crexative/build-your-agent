#!/usr/bin/env bash
# create-agent.sh — Interactive guide to create your first AI agent
# Based on official Claude Code agent specification (.claude/agents/<name>.md)
# Compatible with: Claude Code, Cursor, Devin, Windsurf, Gemini CLI, OpenAI Codex, Aider
set -euo pipefail

# ─── Terminal Colors ───────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# ─── Helpers ───────────────────────────────────────────────────────────────────
print_header() {
  echo ""
  echo -e "${CYAN}${BOLD}╔════════════════════════════════════════════════════════╗${RESET}"
  echo -e "${CYAN}${BOLD}║             🤖  BUILD YOUR AGENT  🤖                  ║${RESET}"
  echo -e "${CYAN}${BOLD}║       Based on official Claude Code agent spec         ║${RESET}"
  echo -e "${CYAN}${BOLD}╚════════════════════════════════════════════════════════╝${RESET}"
  echo ""
}

print_step() {
  echo ""
  echo -e "${BLUE}${BOLD}─── Step $1: $2 ───────────────────────────────────${RESET}"
}

print_success() { echo -e "${GREEN}✔ $1${RESET}"; }
print_warning() { echo -e "${YELLOW}⚠ $1${RESET}"; }
print_error()   { echo -e "${RED}✖ $1${RESET}"; }
print_info()    { echo -e "${DIM}  ℹ $1${RESET}"; }

ask() {
  local var_name="$1"
  local prompt="$2"
  echo -ne "${BOLD}${prompt}${RESET} "
  read -r "$var_name"
}

ask_default() {
  local var_name="$1"
  local prompt="$2"
  local default="$3"
  echo -ne "${BOLD}${prompt} ${DIM}[${default}]${RESET}: "
  read -r "$var_name"
  if [[ -z "${!var_name}" ]]; then
    eval "${var_name}=\"${default}\""
  fi
}

ask_choice() {
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
    echo -ne "${BOLD}${MSG_UI_CHOOSE:-Choose} [1-${num}]: ${RESET}"
    read -r choice
    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= num )); then
      eval "${var_name}=\"\${options[\$((choice-1))]}\""
      break
    fi
    echo -e "${RED}${MSG_UI_INVALID_CHOICE:-Invalid choice. Enter a number between 1 and} ${num}.${RESET}"
  done
}

ask_choice_with_desc() {
  # ask_choice_with_desc <var> <prompt> "label|description" ...
  local var_name="$1"
  local prompt="$2"
  shift 2
  local entries=("$@")
  local num="${#entries[@]}"
  echo -e "${BOLD}${prompt}${RESET}"
  for i in "${!entries[@]}"; do
    local label="${entries[$i]%%|*}"
    local desc="${entries[$i]#*|}"
    echo -e "  ${CYAN}$((i+1))${RESET}) ${BOLD}${label}${RESET}"
    echo -e "     ${DIM}${desc}${RESET}"
  done
  while true; do
    echo -ne "${BOLD}${MSG_UI_CHOOSE:-Choose} [1-${num}]: ${RESET}"
    read -r choice
    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= num )); then
      local selected="${entries[$((choice-1))]%%|*}"
      eval "${var_name}=\"${selected}\""
      break
    fi
    echo -e "${RED}${MSG_UI_INVALID_CHOICE:-Invalid choice. Enter a number between 1 and} ${num}.${RESET}"
  done
}

ask_multiselect() {
  # ask_multiselect <var> <prompt> <option1> <option2> ...
  # Enter numbers separated by spaces, or 0 to skip
  local var_name="$1"
  local prompt="$2"
  shift 2
  local options=("$@")
  local num="${#options[@]}"
  local selected=()
  echo -e "${BOLD}${prompt}${RESET}"
  echo -e "${YELLOW}  ${MSG_UI_MULTISELECT_TIP:-(Enter numbers separated by spaces, e.g.: 1 3 5  |  Enter 0 to skip)}${RESET}"
  for i in "${!options[@]}"; do
    local _label="${options[$i]%%|*}"
    local _desc="${options[$i]#*|}"
    if [[ "$_desc" != "$_label" ]]; then
      echo -e "  ${CYAN}$((i+1))${RESET}) ${BOLD}${_label}${RESET}  ${DIM}— ${_desc}${RESET}"
    else
      echo -e "  ${CYAN}$((i+1))${RESET}) ${_label}"
    fi
  done
  while true; do
    echo -ne "${BOLD}${MSG_UI_SELECT:-Select} [1-${num}]: ${RESET}"
    read -r -a choices
    if [[ "${#choices[@]}" -eq 1 ]] && [[ "${choices[0]}" == "0" ]]; then
      eval "${var_name}=\"\""
      break
    fi
    local valid=true
    selected=()
    for c in "${choices[@]}"; do
      if [[ "$c" =~ ^[0-9]+$ ]] && (( c >= 1 && c <= num )); then
        selected+=("${options[$((c-1))]%%|*}")
      else
        valid=false
        break
      fi
    done
    if [[ "$valid" == true ]] && (( ${#selected[@]} > 0 )); then
      local joined
      joined=$(IFS=', '; echo "${selected[*]}")
      eval "${var_name}=\"${joined}\""
      break
    fi
    echo -e "${RED}${MSG_UI_INVALID_SELECT:-Invalid selection. Enter numbers separated by spaces, or 0 to skip.}${RESET}"
  done
}

confirm() {
  echo -ne "${BOLD}$1 [${MSG_UI_YN:-y/N}]: ${RESET}"
  read -r answer
  [[ "$answer" =~ ^[YySs]$ ]]
}

confirm_yes() {
  echo -ne "${BOLD}$1 [${MSG_UI_YN_DEFAULT:-Y/n}]: ${RESET}"
  read -r answer
  [[ -z "$answer" || "$answer" =~ ^[YySs]$ ]]
}

tools_to_json_array() {
  # Convert "Read, Write, Bash" → ["Read", "Write", "Bash"]
  local input="$1"
  [[ -z "$input" ]] && echo "" && return
  local json='['
  local first=true
  local IFS=','
  for item in $input; do
    item="${item#"${item%%[![:space:]]*}"}"  # ltrim
    item="${item%"${item##*[![:space:]]}"}"  # rtrim
    [[ -z "$item" ]] && continue
    [[ "$first" == false ]] && json+=', '
    json+="\"${item}\""
    first=false
  done
  json+=']'
  echo "$json"
}

# ─── Language Selection ───────────────────────────────────────────────────────
select_language() {
  print_step "0" "Language / Idioma"
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
    MSG_WELCOME="Vamos a crear tu agente de IA siguiendo el formato oficial de Claude Code."
    MSG_STEP_IDENTITY="Identidad del Agente"
    MSG_STEP_MODEL="Selección de Modelo"
    MSG_STEP_PLATFORM="Plataforma Objetivo"
    MSG_STEP_TOOLS="Herramientas del Agente"
    MSG_STEP_BEHAVIOR="Comportamiento y Restricciones"
    MSG_STEP_OUTPUT="Nombre del Archivo"
    MSG_AGENT_NAME="Nombre del agente (kebab-case, ej: mi-asistente):"
    MSG_AGENT_DESC="Descripción corta (será el campo 'description' en el frontmatter):"
    MSG_AGENT_DESC_TIP="Incluye cuándo invocarlo. Ej: 'Especialista en X. Usar PROACTIVAMENTE cuando...'"
    MSG_AGENT_OBJ="¿Cuál es su objetivo principal?"
    MSG_AGENT_ROLE="¿Qué rol desempeña este agente?"
    MSG_MODEL_SELECT="¿Qué modelo usará este agente?"
    MSG_MODEL_SONNET="claude-sonnet-4-6 — Mejor para código y tareas generales (recomendado)"
    MSG_MODEL_OPUS="claude-opus-4-8 — Mejor para razonamiento profundo, orquestación, arquitectura"
    MSG_MODEL_HAIKU="claude-haiku-4-5 — Mejor para tareas ligeras, alto volumen, respuestas rápidas"
    MSG_PLATFORM="¿En qué plataforma desplegar?"
    MSG_COLOR_SELECT="¿Qué color para el ícono del agente en Claude Code?"
    MSG_TOOLS_CLAUDE="¿Qué herramientas puede usar? (nombres oficiales de Claude Code)"
    MSG_TOOLS_GENERIC="¿Qué categorías de herramientas necesita tu agente?"
    MSG_MCP_CONFIRM="¿Usará herramientas MCP externas? (ej: github, filesystem, postgres)"
    MSG_MCP_NAMES="Lista los nombres MCP separados por coma (ej: github, postgres):"
    MSG_BEHAVIOR="¿Cómo debe comportarse? (ej: proactivo, meticuloso, conciso):"
    MSG_CONSTRAINTS="¿Qué NO debe hacer jamás? (restricciones duras):"
    MSG_OUTPUT_FILE="¿Cómo llamar el archivo? (sin extensión):"
    MSG_OUTPUT_FILE_TIP="Será el nombre del archivo .md de tu agente"
    MSG_AUTO_PLACE="¿Auto-colocar en .claude/agents/ del directorio actual?"
    MSG_AUTO_PLACE_TIP="Recomendado: di sí para que Claude Code detecte tu agente automáticamente con /agent ${output_filename}"
    MSG_GENERATING="Generando tu agente..."
    MSG_GENERATED="¡Agente creado exitosamente!"
    MSG_INSTALL_PROMPT="¿Ejecutar el script de instalación de la plataforma ahora?"
    MSG_DONE="Tu agente está en:"
    MSG_NEXT_STEPS="Próximos pasos:"
    MSG_STEP1="1. Revisa y personaliza el archivo generado"
    MSG_STEP2="2. Ajusta el prompt del sistema a tu caso de uso específico"
    MSG_STEP3="3. Mueve el archivo a la ubicación indicada arriba"
    MSG_STEP4="4. Usa /agent ${agent_name} en Claude Code para activarlo"
    MSG_THANKS="¡Gracias por usar Build Your Agent!"
    ROLE_OPT_ORCH="Orquestador|Coordina múltiples agentes, delega subtareas, sintetiza resultados"
    ROLE_OPT_WORK="Trabajador|Ejecuta tareas específicas, llamado por orquestadores"
    ROLE_OPT_SPEC="Especialista|Experto profundo en un dominio (código, seguridad, datos...)"
    ROLE_OPT_GEN="General|Asistente de propósito general, maneja tareas diversas"
    MSG_SKILLS_SEARCHING="Buscando skills relevantes en el ecosistema skills.sh..."
    MSG_SKILLS_FOUND="Skills relevantes encontradas:"
    MSG_SKILLS_NONE="No se encontraron skills específicas. Continuando sin contexto adicional."
    MSG_SKILLS_ENRICH="Instalar una skill enriquecerá el conocimiento de tu agente con patrones probados."
    MSG_SKILLS_PROMPT="¿Instalar alguna? [número o Enter para saltar]:"
    MSG_SKILLS_INSTALLING="Instalando skill:"
    MSG_SKILLS_DONE="Skill instalada. Tu agente la usará como referencia de conocimiento."
    MSG_SKILLS_MANUAL="Puedes instalarla manualmente con:"
    MSG_SKILLS_STEP="Descubrimiento de Skills"
    MSG_SKILLS_REF_TITLE="## Skills de Referencia"
    MSG_SKILLS_REF_BODY="Este agente está enriquecido por la siguiente skill instalada. Invócala cuando necesites referencia especializada del dominio."
    # Cursor
    MSG_CURSOR_STEP="Configuración Nativa de Cursor"
    MSG_CURSOR_ALWAYS="¿Aplicar siempre en todo contexto? (alwaysApply)"
    MSG_CURSOR_ALWAYS_TIP="'Sí' = incluida siempre. 'No' = AI decide según descripción."
    MSG_CURSOR_GLOBS="Patrones de archivos que activan esta regla (ej: **/*.ts, **/*.py):"
    MSG_CURSOR_GLOBS_TIP="Deja vacío para que aplique a todos los archivos."
    # Devin
    MSG_DEVIN_STEP="Formato de Devin"
    MSG_DEVIN_FORMAT="¿Qué formato generar para Devin?"
    MSG_DEVIN_SYSPROMPT="System Prompt|Texto limpio para pegar en el campo de instrucciones de Devin"
    MSG_DEVIN_PLAYBOOK="Playbook|Archivo .devin/playbooks/ con pasos estructurados y trigger"
    MSG_DEVIN_TRIGGER="¿Cuándo debe activarse este playbook? (ej: al revisar código, al hacer deploy):"
    # Codex
    MSG_CODEX_STEP="Configuración Nativa de Codex"
    MSG_CODEX_AGENTS="¿Nombrar el archivo AGENTS.md? (Codex lo detecta automáticamente)"
    MSG_CODEX_AGENTS_TIP="Codex lee AGENTS.md del proyecto automáticamente, sin flags extra."
    # Tool descriptions
    TOOL_READ="Read|leer archivos del proyecto"
    TOOL_WRITE="Write|crear o sobreescribir archivos"
    TOOL_EDIT="Edit|modificar secciones de archivos"
    TOOL_BASH="Bash|ejecutar comandos de terminal"
    TOOL_GLOB="Glob|buscar archivos por nombre/patrón"
    TOOL_GREP="Grep|buscar texto dentro de archivos"
    TOOL_WEBSEARCH="WebSearch|buscar en internet"
    TOOL_WEBFETCH="WebFetch|acceder a URLs específicas"
    TOOL_TASK="Task|crear subtareas / lanzar subagentes"
    TOOL_TODOWRITE="TodoWrite|gestionar listas de tareas"
    TOOL_NOTEBOOKEDIT="NotebookEdit|editar Jupyter notebooks"
    # UI helpers
    MSG_UI_CHOOSE="Elige"
    MSG_UI_SELECT="Selecciona"
    MSG_UI_MULTISELECT_TIP="(Ingresa números separados por espacios, ej: 1 3 5  |  Ingresa 0 para omitir)"
    MSG_UI_INVALID_CHOICE="Opción inválida. Ingresa un número entre 1 y"
    MSG_UI_INVALID_SELECT="Selección inválida. Ingresa números separados por espacios, o 0 para omitir."
    MSG_UI_YN="s/N"
    MSG_UI_YN_DEFAULT="S/n"
  else
    MSG_WELCOME="Let's create your AI agent following the official Claude Code agent specification."
    MSG_STEP_IDENTITY="Agent Identity"
    MSG_STEP_MODEL="Model Selection"
    MSG_STEP_PLATFORM="Target Platform"
    MSG_STEP_TOOLS="Agent Tools"
    MSG_STEP_BEHAVIOR="Behavior & Constraints"
    MSG_STEP_OUTPUT="File Name"
    MSG_AGENT_NAME="Agent name (kebab-case, e.g. my-assistant):"
    MSG_AGENT_DESC="Short description (becomes the frontmatter 'description' field):"
    MSG_AGENT_DESC_TIP="Include when to invoke it. E.g. 'Expert in X. Use PROACTIVELY when...'"
    MSG_AGENT_OBJ="What is its main objective?"
    MSG_AGENT_ROLE="What role does this agent play?"
    MSG_MODEL_SELECT="Which model should this agent use?"
    MSG_MODEL_SONNET="claude-sonnet-4-6 — Best for coding and general tasks (recommended)"
    MSG_MODEL_OPUS="claude-opus-4-8 — Best for deep reasoning, orchestration, architectural decisions"
    MSG_MODEL_HAIKU="claude-haiku-4-5 — Best for lightweight, high-volume, fast-response tasks"
    MSG_PLATFORM="Which platform are you targeting?"
    MSG_COLOR_SELECT="What color for this agent's icon in Claude Code?"
    MSG_TOOLS_CLAUDE="Which tools can it use? (official Claude Code tool names)"
    MSG_TOOLS_GENERIC="What tool categories does your agent need?"
    MSG_MCP_CONFIRM="Will it use external MCP tools? (e.g. github, filesystem, postgres)"
    MSG_MCP_NAMES="List MCP tool names separated by commas (e.g. github, postgres):"
    MSG_BEHAVIOR="How should it behave? (e.g. proactive, meticulous, concise):"
    MSG_CONSTRAINTS="What should it NEVER do? (hard constraints):"
    MSG_OUTPUT_FILE="What to name the file? (no extension):"
    MSG_OUTPUT_FILE_TIP="This will be the filename for your agent's .md file"
    MSG_AUTO_PLACE="Auto-place in .claude/agents/ of current directory?"
    MSG_AUTO_PLACE_TIP="Recommended: say yes so Claude Code detects your agent automatically with /agent ${output_filename}"
    MSG_GENERATING="Generating your agent..."
    MSG_GENERATED="Agent created successfully!"
    MSG_INSTALL_PROMPT="Run the platform install script now?"
    MSG_DONE="Your agent file is at:"
    MSG_NEXT_STEPS="Next steps:"
    MSG_STEP1="1. Review and customize the generated file"
    MSG_STEP2="2. Refine the system prompt for your specific use case"
    MSG_STEP3="3. Move the file to the location shown above"
    MSG_STEP4="4. Use /agent ${agent_name} in Claude Code to activate it"
    MSG_THANKS="Thanks for using Build Your Agent!"
    ROLE_OPT_ORCH="Orchestrator|Coordinates multiple agents, delegates subtasks, synthesizes results"
    ROLE_OPT_WORK="Worker|Executes specific tasks, called by orchestrators"
    ROLE_OPT_SPEC="Specialist|Deep expert in one domain (code, security, data...)"
    ROLE_OPT_GEN="General|General-purpose assistant, handles diverse tasks"
    MSG_SKILLS_SEARCHING="Searching the skills.sh ecosystem for relevant skills..."
    MSG_SKILLS_FOUND="Relevant skills found:"
    MSG_SKILLS_NONE="No specific skills found. Continuing without additional context."
    MSG_SKILLS_ENRICH="Installing a skill will enrich your agent with battle-tested domain patterns."
    MSG_SKILLS_PROMPT="Install one? [number or Enter to skip]:"
    MSG_SKILLS_INSTALLING="Installing skill:"
    MSG_SKILLS_DONE="Skill installed. Your agent will reference it as domain knowledge."
    MSG_SKILLS_MANUAL="You can install it manually with:"
    MSG_SKILLS_STEP="Skill Discovery"
    MSG_SKILLS_REF_TITLE="## Reference Skills"
    MSG_SKILLS_REF_BODY="This agent is enriched by the following installed skill. Invoke it when you need specialized domain reference."
    # Cursor
    MSG_CURSOR_STEP="Cursor Native Configuration"
    MSG_CURSOR_ALWAYS="Apply to all contexts always? (alwaysApply)"
    MSG_CURSOR_ALWAYS_TIP="'Yes' = always injected. 'No' = AI decides based on description."
    MSG_CURSOR_GLOBS="File patterns that trigger this rule (e.g. **/*.ts, **/*.py):"
    MSG_CURSOR_GLOBS_TIP="Leave empty to apply to all files."
    # Devin
    MSG_DEVIN_STEP="Devin Format"
    MSG_DEVIN_FORMAT="Which Devin format to generate?"
    MSG_DEVIN_SYSPROMPT="System Prompt|Clean text to paste in Devin's instruction field"
    MSG_DEVIN_PLAYBOOK="Playbook|.devin/playbooks/ file with structured steps and trigger"
    MSG_DEVIN_TRIGGER="When should this playbook activate? (e.g. when reviewing code, when deploying):"
    # Codex
    MSG_CODEX_STEP="Codex Native Configuration"
    MSG_CODEX_AGENTS="Name the file AGENTS.md? (Codex auto-detects it)"
    MSG_CODEX_AGENTS_TIP="Codex reads AGENTS.md from the project root automatically, no flags needed."
    # Tool descriptions
    TOOL_READ="Read|read project files"
    TOOL_WRITE="Write|create or overwrite files"
    TOOL_EDIT="Edit|modify sections of existing files"
    TOOL_BASH="Bash|run terminal commands"
    TOOL_GLOB="Glob|find files by name/pattern"
    TOOL_GREP="Grep|search text inside files"
    TOOL_WEBSEARCH="WebSearch|search the web"
    TOOL_WEBFETCH="WebFetch|fetch specific URLs"
    TOOL_TASK="Task|create subtasks / launch subagents"
    TOOL_TODOWRITE="TodoWrite|manage task lists"
    TOOL_NOTEBOOKEDIT="NotebookEdit|edit Jupyter notebooks"
    # UI helpers
    MSG_UI_CHOOSE="Choose"
    MSG_UI_SELECT="Select"
    MSG_UI_MULTISELECT_TIP="(Enter numbers separated by spaces, e.g.: 1 3 5  |  Enter 0 to skip)"
    MSG_UI_INVALID_CHOICE="Invalid choice. Enter a number between 1 and"
    MSG_UI_INVALID_SELECT="Invalid selection. Enter numbers separated by spaces, or 0 to skip."
    MSG_UI_YN="y/N"
    MSG_UI_YN_DEFAULT="Y/n"
  fi
}

# ─── Role-Based Content Defaults ──────────────────────────────────────────────
get_role_defaults() {
  local role="$1"
  if [[ "$LANG_CODE" == "es" ]]; then
    case "$role" in
      Orquestador)
        ROLE_CAPS="- Descomponer tareas complejas en subtareas manejables\n- Delegar trabajo a agentes especializados usando herramienta Task\n- Ejecutar subtareas en paralelo cuando sea posible\n- Sintetizar resultados de múltiples fuentes\n- Mantener contexto y estado a lo largo del proceso"
        ROLE_PROC="Al recibir una tarea:\n1. Analiza el alcance y complejidad total\n2. Identifica qué agentes especializados se necesitan\n3. Delega subtareas en paralelo cuando sea posible\n4. Verifica y consolida los resultados recibidos\n5. Reporta el resultado final con un resumen claro"
        ROLE_OUT="- Listas numeradas para planes y progreso\n- Estado de cada subtarea delegada\n- Resumen de resultados al finalizar\n- Indica qué agentes fueron invocados y por qué"
        ;;
      Trabajador)
        ROLE_CAPS="- Ejecutar tareas específicas con alta precisión\n- Reportar resultados en formato estructurado\n- Manejar errores y casos borde de forma robusta\n- Operar dentro de los límites de permisos definidos\n- Completar la tarea asignada sin desviarse del alcance"
        ROLE_PROC="Al recibir una tarea:\n1. Confirma que está dentro de tu alcance y permisos\n2. Planifica los pasos necesarios antes de ejecutar\n3. Ejecuta metódicamente, verificando cada paso\n4. Retorna el resultado en formato estructurado"
        ROLE_OUT="- Formato estructurado (JSON o Markdown según contexto)\n- Métricas de éxito/fallo\n- Errores con contexto suficiente para depuración\n- Sin narrativa innecesaria — directo al resultado"
        ;;
      Especialista)
        ROLE_CAPS="- Aplicar conocimiento especializado del dominio\n- Identificar problemas específicos del área con alta precisión\n- Seguir y hacer cumplir las mejores prácticas del dominio\n- Proveer recomendaciones accionables basadas en expertise\n- Explicar el razonamiento detrás de cada hallazgo"
        ROLE_PROC="Al recibir una solicitud:\n1. Lee y comprende el contexto completo antes de actuar\n2. Aplica criterios especializados de revisión y análisis\n3. Clasifica hallazgos por severidad e impacto\n4. Provee recomendaciones concretas y accionables"
        ROLE_OUT="- Hallazgos organizados por severidad: CRÍTICO / ALTO / MEDIO / BAJO\n- Ejemplos o casos concretos cuando aplique\n- Veredicto final y recomendación de acción\n- Referencias a mejores prácticas del dominio"
        ;;
      *)
        ROLE_CAPS="- Entender y completar tareas diversas de manera efectiva\n- Leer, analizar y modificar archivos según sea necesario\n- Usar las herramientas disponibles de forma apropiada\n- Comunicarse con claridad y precisión con el usuario"
        ROLE_PROC="Al recibir una solicitud:\n1. Entiende el objetivo y el contexto completo\n2. Planifica los pasos necesarios antes de ejecutar\n3. Ejecuta cuidadosamente, verificando cada paso\n4. Reporta el resultado y los posibles próximos pasos"
        ROLE_OUT="- Respuestas claras y estructuradas con encabezados cuando aplique\n- Bloques de código para comandos, rutas y fragmentos\n- Resumen de acciones completadas al final\n- Pide clarificación ante ambigüedad antes de actuar"
        ;;
    esac
  else
    case "$role" in
      Orchestrator)
        ROLE_CAPS="- Break complex tasks into manageable subtasks\n- Delegate work to specialized agents using the Task tool\n- Run subtasks in parallel when possible\n- Synthesize results from multiple sources\n- Maintain context and state throughout the process"
        ROLE_PROC="When given a task:\n1. Analyze the full scope and complexity\n2. Identify which specialized agents are needed\n3. Delegate subtasks in parallel when possible\n4. Verify and consolidate received results\n5. Report the final result with a clear summary"
        ROLE_OUT="- Numbered lists for plans and progress tracking\n- Status report for each delegated subtask\n- Results summary when complete\n- Indicate which agents were invoked and why"
        ;;
      Worker)
        ROLE_CAPS="- Execute specific tasks with high precision\n- Report results in structured format\n- Handle errors and edge cases robustly\n- Operate within defined permission boundaries\n- Complete the assigned task without scope drift"
        ROLE_PROC="When given a task:\n1. Confirm it falls within your scope and permissions\n2. Plan the required steps before executing\n3. Execute methodically, verifying each step\n4. Return the result in structured format"
        ROLE_OUT="- Structured format (JSON or Markdown as appropriate)\n- Success/failure metrics\n- Errors with enough context for debugging\n- No unnecessary narrative — straight to the result"
        ;;
      Specialist)
        ROLE_CAPS="- Apply deep domain knowledge and expertise\n- Identify domain-specific issues with high precision\n- Enforce domain best practices and standards\n- Provide actionable recommendations backed by expertise\n- Explain the reasoning behind each finding"
        ROLE_PROC="When given a request:\n1. Read and understand the full context before acting\n2. Apply specialized review and analysis criteria\n3. Classify findings by severity and impact\n4. Provide concrete, actionable recommendations"
        ROLE_OUT="- Findings organized by severity: CRITICAL / HIGH / MEDIUM / LOW\n- Code examples or concrete cases where applicable\n- Final verdict and recommended action\n- References to domain best practices"
        ;;
      *)
        ROLE_CAPS="- Understand and complete diverse tasks effectively\n- Read, analyze, and modify files as needed\n- Use available tools appropriately for each situation\n- Communicate clearly and precisely with the user"
        ROLE_PROC="When given a request:\n1. Understand the goal and full context\n2. Plan the required steps before executing\n3. Execute carefully, verifying each step\n4. Report the result and potential next steps"
        ROLE_OUT="- Clear structured responses with headings where appropriate\n- Code blocks for commands, paths, and snippets\n- Summary of completed actions at the end\n- Ask for clarification on ambiguous requests before acting"
        ;;
    esac
  fi
}

# ─── Skill Discovery ──────────────────────────────────────────────────────────
extract_keywords() {
  # Pull first 3 meaningful words from description + objective
  echo "$1 $2" \
    | tr '[:upper:]' '[:lower:]' \
    | tr -cs '[:alpha:]' ' ' \
    | tr ' ' '\n' \
    | grep -v -E '^(the|a|an|is|for|use|when|and|or|in|to|of|with|this|that|be|do|not|its|as|by|on|at|can|will|should|must|may|you|your|my|our|i|we|they|are|was|were|has|have|had|been|am|proactively|after|before|writing|creating|building|reviewing|testing|helping|providing|generating|expert|specialist|assistant|agent|general|worker|use|it|an)$' \
    | grep -v '^.\{1\}$' \
    | head -3 \
    | tr '\n' ' ' \
    | sed 's/ *$//'
}

discover_skills() {
  [[ "${BYA_DEMO:-}" == "1" ]] && return 0
  command -v npx &>/dev/null || return 0

  local keywords
  keywords=$(extract_keywords "$agent_description" "$agent_objective")
  [[ -z "$keywords" ]] && return 0

  print_step "1.5" "$MSG_SKILLS_STEP"
  print_info "$MSG_SKILLS_SEARCHING"

  local raw
  raw=$(npx skills find "$keywords" 2>/dev/null \
    | sed 's/\x1b\[[0-9;]*m//g' \
    | grep -v '^$' \
    | grep -v 'Install with')

  [[ -z "$raw" ]] && { print_info "$MSG_SKILLS_NONE"; return 0; }

  # Parse skill refs and URLs from output
  local -a skill_refs=() skill_urls=()
  while IFS= read -r line; do
    if [[ "$line" =~ ^[a-zA-Z] ]] && [[ "$line" == *@* ]] && [[ "$line" == *installs* ]]; then
      skill_refs+=("${line%%[[:space:]]*}|$(echo "$line" | grep -oE '[0-9.]+K?[[:space:]]+installs')")
    elif [[ "$line" == *https://skills.sh/* ]]; then
      local _url="${line#*https://}"
      skill_urls+=("https://${_url}")
    fi
  done <<< "$raw"

  [[ ${#skill_refs[@]} -eq 0 ]] && { print_info "$MSG_SKILLS_NONE"; return 0; }

  echo ""
  echo -e "${GREEN}${BOLD}${MSG_SKILLS_FOUND}${RESET}"
  local max=$(( ${#skill_refs[@]} < 3 ? ${#skill_refs[@]} : 3 ))
  for (( i=0; i<max; i++ )); do
    local ref="${skill_refs[$i]%%|*}"
    local installs="${skill_refs[$i]#*|}"
    echo -e "  ${CYAN}$((i+1))${RESET}) ${BOLD}${ref}${RESET}  ${DIM}${installs}${RESET}"
    [[ -n "${skill_urls[$i]:-}" ]] && echo -e "     ${DIM}${skill_urls[$i]}${RESET}"
  done

  echo ""
  echo -e "${YELLOW}${MSG_SKILLS_ENRICH}${RESET}"
  echo -ne "${BOLD}${MSG_SKILLS_PROMPT} ${RESET}"
  read -r skill_choice

  agent_installed_skill=""
  if [[ "$skill_choice" =~ ^[1-3]$ ]] && (( skill_choice <= max )); then
    local chosen="${skill_refs[$((skill_choice-1))]%%|*}"
    echo ""
    print_info "${MSG_SKILLS_INSTALLING} ${chosen}"
    if npx skills add "$chosen" -g -y 2>&1 | tail -3; then
      print_success "$MSG_SKILLS_DONE"
      agent_installed_skill="$chosen"
    else
      print_warning "$MSG_SKILLS_MANUAL"
      echo "  npx skills add ${chosen} -g -y"
    fi
  fi
}

# ─── Platform Install Notes ────────────────────────────────────────────────────
get_platform_note() {
  case "$agent_platform" in
    "Claude Code")
      [[ "$LANG_CODE" == "es" ]] \
        && echo "Guarda como \`.claude/agents/${output_filename}.md\`. Actívalo con \`/agent ${output_filename}\` en Claude Code." \
        || echo "Save as \`.claude/agents/${output_filename}.md\`. Activate with \`/agent ${output_filename}\` in Claude Code." ;;
    "Cursor")
      [[ "$LANG_CODE" == "es" ]] \
        && echo "Guarda en \`.cursor/rules/${output_filename}.md\` o referéncialo en \`.cursorrules\`." \
        || echo "Save in \`.cursor/rules/${output_filename}.md\` or reference it in \`.cursorrules\`." ;;
    "Devin")
      [[ "$LANG_CODE" == "es" ]] \
        && echo "Pega el contenido en el campo de prompt del sistema al iniciar una sesión de Devin." \
        || echo "Paste the content in the system prompt field when starting a Devin session." ;;
    "Windsurf")
      [[ "$LANG_CODE" == "es" ]] \
        && echo "Guarda en \`.windsurf/rules/${output_filename}.md\` o en Configuración → Cascade → Global Rules." \
        || echo "Save in \`.windsurf/rules/${output_filename}.md\` or in Settings → Cascade → Global Rules." ;;
    "Gemini CLI")
      [[ "$LANG_CODE" == "es" ]] \
        && echo "Usa: \`gemini --context ${output_filename}.md\` o coloca en \`~/.gemini/agents/${output_filename}.md\`." \
        || echo "Use: \`gemini --context ${output_filename}.md\` or place in \`~/.gemini/agents/${output_filename}.md\`." ;;
    "OpenAI Codex")
      if [[ "$codex_agents_md" == true ]]; then
        [[ "$LANG_CODE" == "es" ]] \
          && echo "Archivo generado como \`AGENTS.md\`. Codex lo detecta automáticamente en el root del proyecto." \
          || echo "File generated as \`AGENTS.md\`. Codex detects it automatically in the project root."
      else
        [[ "$LANG_CODE" == "es" ]] \
          && echo "Usa: \`codex --system-prompt ${output_filename}.md\`" \
          || echo "Use: \`codex --system-prompt ${output_filename}.md\`"
      fi ;;
    "Aider")
      [[ "$LANG_CODE" == "es" ]] \
        && echo "Usa: \`aider --system-prompt ${output_filename}.md\` o configura en \`.aider.conf.yml\`." \
        || echo "Use: \`aider --system-prompt ${output_filename}.md\` or configure in \`.aider.conf.yml\`." ;;
  esac
}

# ─── Platform-Specific Config ──────────────────────────────────────────────────
gather_platform_config() {
  local devin_format_choice=""
  case "$agent_platform" in
    "Cursor")
      print_step "3b" "$MSG_CURSOR_STEP"
      echo ""
      print_info "$MSG_CURSOR_ALWAYS_TIP"
      if confirm "$MSG_CURSOR_ALWAYS"; then
        cursor_always_apply=true
      fi
      echo ""
      print_info "$MSG_CURSOR_GLOBS_TIP"
      ask cursor_globs "$MSG_CURSOR_GLOBS"
      ;;
    "Devin")
      print_step "3b" "$MSG_DEVIN_STEP"
      echo ""
      ask_choice_with_desc devin_format_choice "$MSG_DEVIN_FORMAT" \
        "$MSG_DEVIN_SYSPROMPT" \
        "$MSG_DEVIN_PLAYBOOK"
      if [[ "$devin_format_choice" == "Playbook" ]]; then
        devin_playbook=true
        echo ""
        ask devin_trigger "$MSG_DEVIN_TRIGGER"
      fi
      ;;
    "OpenAI Codex")
      print_step "3b" "$MSG_CODEX_STEP"
      echo ""
      print_info "$MSG_CODEX_AGENTS_TIP"
      if confirm "$MSG_CODEX_AGENTS"; then
        codex_agents_md=true
      fi
      ;;
  esac
}

# ─── Generate Agent File ───────────────────────────────────────────────────────
generate_agent_file() {
  get_role_defaults "$agent_role"

  local output_path
  if [[ "$agent_platform" == "OpenAI Codex" ]] && [[ "$codex_agents_md" == true ]]; then
    output_path="AGENTS.md"
  elif [[ "$agent_platform" == "Devin" ]] && [[ "$devin_playbook" == true ]] && [[ "$auto_place" == true ]]; then
    mkdir -p ".devin/playbooks"
    output_path=".devin/playbooks/${output_filename}.md"
  elif [[ "$agent_platform" == "Cursor" ]] && [[ "$auto_place" == true ]]; then
    mkdir -p ".cursor/rules"
    output_path=".cursor/rules/${output_filename}.md"
  elif [[ "$agent_platform" == "Windsurf" ]] && [[ "$auto_place" == true ]]; then
    mkdir -p ".windsurf/rules"
    output_path=".windsurf/rules/${output_filename}.md"
  elif [[ "$agent_platform" == "Claude Code" ]] && [[ "$auto_place" == true ]]; then
    mkdir -p ".claude/agents"
    output_path=".claude/agents/${output_filename}.md"
  else
    output_path="${output_filename}.md"
  fi

  # Build optional frontmatter lines
  local tools_json=""
  if [[ "$agent_platform" == "Claude Code" ]] && [[ -n "$agent_tools" ]]; then
    tools_json=$(tools_to_json_array "$agent_tools")
  fi

  # Expand \n sequences in role content
  local role_caps role_proc role_out
  role_caps=$(printf '%b' "$ROLE_CAPS")
  role_proc=$(printf '%b' "$ROLE_PROC")
  role_out=$(printf '%b' "$ROLE_OUT")

  # Build optional MCP section
  local mcp_section=""
  if [[ -n "$agent_mcp_tools" ]]; then
    if [[ "$LANG_CODE" == "es" ]]; then
      mcp_section="## Herramientas MCP

Este agente utiliza las siguientes herramientas MCP externas:

${agent_mcp_tools}

Asegúrate de que los servidores MCP correspondientes estén configurados en tu entorno."
    else
      mcp_section="## MCP Tools

This agent uses the following external MCP tools:

${agent_mcp_tools}

Make sure the corresponding MCP servers are configured in your environment."
    fi
  fi

  # ── Write the file ─────────────────────────────────────────────────────────
  {
    if [[ "$agent_platform" == "Claude Code" ]]; then
      # Frontmatter (official Claude Code format)
      echo "---"
      echo "name: ${agent_name}"
      echo "description: ${agent_description}"
      echo "model: ${agent_model}"
      [[ -n "$tools_json" ]]  && echo "tools: ${tools_json}"
      [[ -n "$agent_color" ]] && echo "color: ${agent_color}"
      echo "---"
      echo ""
    fi

    if [[ "$LANG_CODE" == "es" ]]; then

      if [[ "$agent_platform" == "Claude Code" ]]; then
        # ── Claude Code / Spanish ──────────────────────────────────────────────
        local desc_clean_es="${agent_description%[.!?]}"
        echo "Eres ${agent_name}, ${desc_clean_es}."
        echo ""
        echo "## Tu Rol"
        echo ""
        echo "$role_caps"
        echo ""
        echo "## Objetivo"
        echo ""
        echo "${agent_objective}"
        echo ""
        echo "## Proceso"
        echo ""
        echo "$role_proc"
        echo ""
        echo "## Comportamiento"
        echo ""
        echo "- ${agent_behavior}"
        echo "- Pide confirmación antes de cualquier acción irreversible"
        echo "- Sé conciso y directo — sin relleno innecesario"
        echo "- Prefiere pasos incrementales y verificables sobre acciones grandes"
        echo "- Explica el razonamiento detrás de decisiones importantes"
        echo "- Por defecto, opera de forma segura y reversible"
        echo ""
        echo "## Restricciones"
        echo ""
        echo "- ${agent_constraints}"
        echo "- NO accedas ni modifiques archivos fuera del directorio de trabajo"
        echo "- NO almacenes ni transmitas datos sensibles (contraseñas, API keys, PII)"
        echo "- NO ejecutes comandos destructivos sin confirmación explícita"
        echo "- NO hagas commits ni push a git sin aprobación del usuario"
        echo ""
        echo "## Formato de Salida"
        echo ""
        echo "$role_out"
        if [[ -n "$mcp_section" ]]; then
          echo ""
          echo "$mcp_section"
        fi

      else
        # ── Other platforms / Spanish ──────────────────────────────────────────
        local desc_clean_es="${agent_description%[.!?]}"
        case "$agent_platform" in
          "Cursor")
            echo "---"
            echo "description: ${agent_description}"
            [[ "$cursor_always_apply" == true ]] && echo "alwaysApply: true" || echo "alwaysApply: false"
            if [[ -n "$cursor_globs" ]]; then
              echo "globs: [\"${cursor_globs//,/\", \"}\"]"
            fi
            echo "---"
            echo ""
            echo "Eres ${agent_name}, ${desc_clean_es}."
            echo ""
            echo "## Tu Rol"
            echo ""
            echo "$role_caps"
            echo ""
            echo "## Objetivo"
            echo ""
            echo "${agent_objective}"
            echo ""
            echo "## Proceso"
            echo ""
            echo "$role_proc"
            echo ""
            echo "## Comportamiento"
            echo ""
            echo "- ${agent_behavior}"
            echo "- Pide confirmación antes de cualquier acción irreversible"
            echo "- Sé conciso y directo"
            echo "- Prefiere pasos incrementales y verificables"
            echo "- Opera de forma segura y reversible por defecto"
            echo ""
            echo "## Restricciones"
            echo ""
            echo "- ${agent_constraints}"
            echo "- NO almacenes ni transmitas datos sensibles"
            echo "- NO ejecutes comandos destructivos sin confirmación"
            echo ""
            echo "## Formato de Salida"
            echo ""
            echo "$role_out"
            ;;
          "OpenAI Codex")
            echo "# Instrucciones del Agente — ${agent_name}"
            echo ""
            echo "Eres ${agent_name}, ${desc_clean_es}."
            echo ""
            echo "## Objetivo"
            echo ""
            echo "${agent_objective}"
            echo ""
            echo "## Capacidades"
            echo ""
            echo "$role_caps"
            echo ""
            echo "## Cómo Trabajar"
            echo ""
            echo "$role_proc"
            echo ""
            echo "## Comportamiento"
            echo ""
            echo "- ${agent_behavior}"
            echo "- Pide confirmación antes de acciones irreversibles"
            echo "- Sé conciso — sin relleno"
            echo "- Opera de forma segura y reversible por defecto"
            echo ""
            echo "## Restricciones Duras"
            echo ""
            echo "- ${agent_constraints}"
            echo "- Nunca almacenes ni transmitas datos sensibles"
            echo "- Nunca ejecutes comandos destructivos sin confirmación"
            echo ""
            echo "## Formato de Salida"
            echo ""
            echo "$role_out"
            ;;
          "Devin")
            if [[ "$devin_playbook" == true ]]; then
              echo "# Playbook: ${agent_name}"
              echo ""
              echo "## Cuándo Usar"
              echo ""
              echo "${devin_trigger:-${agent_description}}"
              echo ""
              echo "## Objetivo"
              echo ""
              echo "${agent_objective}"
              echo ""
              echo "## Pasos"
              echo ""
              echo "$role_proc"
              echo ""
              echo "## Comportamiento del Agente"
              echo ""
              echo "- ${agent_behavior}"
              echo "- Pide confirmación antes de acciones irreversibles"
              echo "- Opera de forma segura y reversible por defecto"
              echo ""
              echo "## Restricciones"
              echo ""
              echo "- ${agent_constraints}"
              echo "- Nunca almacenes datos sensibles"
              echo "- Nunca ejecutes comandos destructivos sin confirmación"
              echo ""
              echo "## Salida Esperada"
              echo ""
              echo "$role_out"
            else
              echo "# ${agent_name}"
              echo ""
              echo "Eres ${agent_name}, ${desc_clean_es}."
              echo ""
              echo "## Objetivo"
              echo ""
              echo "${agent_objective}"
              echo ""
              echo "## Instrucciones"
              echo ""
              echo "$role_caps"
              echo ""
              echo "$role_proc"
              echo ""
              echo "## Comportamiento"
              echo ""
              echo "- ${agent_behavior}"
              echo "- Pide confirmación antes de acciones irreversibles"
              echo "- Sé conciso y directo"
              echo "- Opera de forma segura y reversible por defecto"
              echo ""
              echo "## Restricciones"
              echo ""
              echo "- ${agent_constraints}"
              echo "- Nunca almacenes ni transmitas datos sensibles"
              echo "- Nunca ejecutes comandos destructivos sin confirmación"
              echo ""
              echo "## Formato de Salida"
              echo ""
              echo "$role_out"
            fi
            ;;
          *)
            local today_es platform_note_es
            today_es=$(date +%Y-%m-%d 2>/dev/null || echo "unknown")
            platform_note_es=$(get_platform_note)
            echo "# Agente: ${agent_name}"
            echo ""
            echo "## Descripción"
            echo ""
            echo "${agent_description}"
            echo ""
            echo "## Objetivo"
            echo ""
            echo "${agent_objective}"
            echo ""
            echo "## Herramientas Disponibles"
            echo ""
            echo "${agent_tools:-N/A}"
            echo ""
            echo "## Tu Rol"
            echo ""
            echo "$role_caps"
            echo ""
            echo "## Proceso"
            echo ""
            echo "$role_proc"
            echo ""
            echo "## Comportamiento"
            echo ""
            echo "- ${agent_behavior}"
            echo "- Pide confirmación antes de acciones irreversibles"
            echo "- Sé conciso y directo"
            echo "- Prefiere pasos incrementales y verificables"
            echo "- Opera de forma segura y reversible por defecto"
            echo ""
            echo "## Restricciones"
            echo ""
            echo "- ${agent_constraints}"
            echo "- NO almacenes ni transmitas datos sensibles"
            echo "- NO ejecutes comandos destructivos sin confirmación"
            echo "- NO accedas a archivos fuera del directorio de trabajo"
            echo ""
            echo "## Formato de Salida"
            echo ""
            echo "$role_out"
            if [[ -n "$mcp_section" ]]; then
              echo ""
              echo "$mcp_section"
            fi
            echo ""
            echo "## Instrucciones de Plataforma"
            echo ""
            echo "**${agent_platform}**: ${platform_note_es}"
            echo ""
            echo "---"
            echo ""
            echo "> Modelo: ${agent_model} | Plataforma: ${agent_platform} | Creado: ${today_es}"
            ;;
        esac
      fi

    else  # English

      if [[ "$agent_platform" == "Claude Code" ]]; then
        # ── Claude Code / English ──────────────────────────────────────────────
        local desc_clean="${agent_description%[.!?]}"
        echo "You are ${agent_name}, ${desc_clean}."
        echo ""
        echo "## Your Role"
        echo ""
        echo "$role_caps"
        echo ""
        echo "## Objective"
        echo ""
        echo "${agent_objective}"
        echo ""
        echo "## Process"
        echo ""
        echo "$role_proc"
        echo ""
        echo "## Behavior"
        echo ""
        echo "- ${agent_behavior}"
        echo "- Ask for confirmation before any irreversible action"
        echo "- Be concise and direct — avoid unnecessary filler"
        echo "- Prefer incremental, verifiable steps over large single actions"
        echo "- Explain the reasoning behind significant decisions"
        echo "- Default to safe, reversible operations"
        echo ""
        echo "## Constraints"
        echo ""
        echo "- ${agent_constraints}"
        echo "- Do NOT access or modify files outside the defined working directory"
        echo "- Do NOT store or transmit sensitive data (passwords, API keys, PII)"
        echo "- Do NOT execute destructive commands without explicit user confirmation"
        echo "- Do NOT commit or push to git without explicit user approval"
        echo ""
        echo "## Output Format"
        echo ""
        echo "$role_out"
        if [[ -n "$mcp_section" ]]; then
          echo ""
          echo "$mcp_section"
        fi

      else
        # ── Other platforms / English ──────────────────────────────────────────
        local desc_clean="${agent_description%[.!?]}"
        case "$agent_platform" in
          "Cursor")
            echo "---"
            echo "description: ${agent_description}"
            [[ "$cursor_always_apply" == true ]] && echo "alwaysApply: true" || echo "alwaysApply: false"
            if [[ -n "$cursor_globs" ]]; then
              echo "globs: [\"${cursor_globs//,/\", \"}\"]"
            fi
            echo "---"
            echo ""
            echo "You are ${agent_name}, ${desc_clean}."
            echo ""
            echo "## Your Role"
            echo ""
            echo "$role_caps"
            echo ""
            echo "## Objective"
            echo ""
            echo "${agent_objective}"
            echo ""
            echo "## Process"
            echo ""
            echo "$role_proc"
            echo ""
            echo "## Behavior"
            echo ""
            echo "- ${agent_behavior}"
            echo "- Ask for confirmation before any irreversible action"
            echo "- Be concise and direct"
            echo "- Prefer incremental, verifiable steps"
            echo "- Default to safe, reversible operations"
            echo ""
            echo "## Constraints"
            echo ""
            echo "- ${agent_constraints}"
            echo "- Do NOT store or transmit sensitive data"
            echo "- Do NOT execute destructive commands without confirmation"
            echo ""
            echo "## Output Format"
            echo ""
            echo "$role_out"
            ;;
          "OpenAI Codex")
            echo "# Agent Instructions — ${agent_name}"
            echo ""
            echo "You are ${agent_name}, ${desc_clean}."
            echo ""
            echo "## Objective"
            echo ""
            echo "${agent_objective}"
            echo ""
            echo "## Your Capabilities"
            echo ""
            echo "$role_caps"
            echo ""
            echo "## How to Work"
            echo ""
            echo "$role_proc"
            echo ""
            echo "## Behavior Guidelines"
            echo ""
            echo "- ${agent_behavior}"
            echo "- Ask for confirmation before irreversible actions"
            echo "- Be concise — no filler"
            echo "- Default to safe, reversible operations"
            echo ""
            echo "## Hard Constraints"
            echo ""
            echo "- ${agent_constraints}"
            echo "- Never store or transmit sensitive data"
            echo "- Never execute destructive commands without confirmation"
            echo ""
            echo "## Output Format"
            echo ""
            echo "$role_out"
            ;;
          "Devin")
            if [[ "$devin_playbook" == true ]]; then
              echo "# Playbook: ${agent_name}"
              echo ""
              echo "## When to Use"
              echo ""
              echo "${devin_trigger:-${agent_description}}"
              echo ""
              echo "## Objective"
              echo ""
              echo "${agent_objective}"
              echo ""
              echo "## Steps"
              echo ""
              echo "$role_proc"
              echo ""
              echo "## Agent Behavior"
              echo ""
              echo "- ${agent_behavior}"
              echo "- Ask for confirmation before irreversible actions"
              echo "- Default to safe, reversible operations"
              echo ""
              echo "## Constraints"
              echo ""
              echo "- ${agent_constraints}"
              echo "- Never store sensitive data"
              echo "- Never run destructive commands without confirmation"
              echo ""
              echo "## Expected Output"
              echo ""
              echo "$role_out"
            else
              echo "# ${agent_name}"
              echo ""
              echo "You are ${agent_name}, ${desc_clean}."
              echo ""
              echo "## Objective"
              echo ""
              echo "${agent_objective}"
              echo ""
              echo "## Instructions"
              echo ""
              echo "$role_caps"
              echo ""
              echo "$role_proc"
              echo ""
              echo "## Behavior"
              echo ""
              echo "- ${agent_behavior}"
              echo "- Ask for confirmation before irreversible actions"
              echo "- Be concise and direct"
              echo "- Default to safe, reversible operations"
              echo ""
              echo "## Constraints"
              echo ""
              echo "- ${agent_constraints}"
              echo "- Never store or transmit sensitive data"
              echo "- Never run destructive commands without confirmation"
              echo ""
              echo "## Output Format"
              echo ""
              echo "$role_out"
            fi
            ;;
          *)
            local today platform_note
            today=$(date +%Y-%m-%d 2>/dev/null || echo "unknown")
            platform_note=$(get_platform_note)
            echo "# Agent: ${agent_name}"
            echo ""
            echo "## Description"
            echo ""
            echo "${agent_description}"
            echo ""
            echo "## Objective"
            echo ""
            echo "${agent_objective}"
            echo ""
            echo "## Available Tools"
            echo ""
            echo "${agent_tools:-N/A}"
            echo ""
            echo "## Your Role"
            echo ""
            echo "$role_caps"
            echo ""
            echo "## Process"
            echo ""
            echo "$role_proc"
            echo ""
            echo "## Behavior"
            echo ""
            echo "- ${agent_behavior}"
            echo "- Ask for confirmation before irreversible actions"
            echo "- Be concise and direct"
            echo "- Prefer incremental, verifiable steps"
            echo "- Default to safe, reversible operations"
            echo ""
            echo "## Constraints"
            echo ""
            echo "- ${agent_constraints}"
            echo "- Do NOT store or transmit sensitive data"
            echo "- Do NOT execute destructive commands without confirmation"
            echo "- Do NOT access files outside the working directory"
            echo ""
            echo "## Output Format"
            echo ""
            echo "$role_out"
            if [[ -n "$mcp_section" ]]; then
              echo ""
              echo "$mcp_section"
            fi
            echo ""
            echo "## Platform Instructions"
            echo ""
            echo "**${agent_platform}**: ${platform_note}"
            echo ""
            echo "---"
            echo ""
            echo "> Model: ${agent_model} | Platform: ${agent_platform} | Created: ${today}"
            ;;
        esac
      fi

    fi  # end LANG_CODE

    # Optional: installed skill reference
    if [[ -n "${agent_installed_skill:-}" ]]; then
      echo ""
      echo "$MSG_SKILLS_REF_TITLE"
      echo ""
      echo "$MSG_SKILLS_REF_BODY"
      echo ""
      echo "- \`${agent_installed_skill}\` — install: \`npx skills add ${agent_installed_skill} -g -y\`"
    fi

    echo ""
    echo "---"
    echo ""
    echo "*Generated with [Build Your Agent](https://github.com/crexative/build-your-agent)*"

  } > "$output_path"

  print_success "$MSG_GENERATED"
  echo ""
  echo -e "  ${BOLD}${MSG_DONE}${RESET} ${CYAN}${output_path}${RESET}"
}

# ─── Install Platform ─────────────────────────────────────────────────────────
run_install() {
  local script_name=""
  case "$agent_platform" in
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
    print_step "●" "Running install/${script_name}.sh"
    bash "$install_script"
  else
    print_warning "Install script not found: install/${script_name}.sh"
    print_info "Follow the platform instructions in the generated agent file."
  fi
}

# ─── Summary ──────────────────────────────────────────────────────────────────
get_activation_step() {
  case "$agent_platform" in
    "Claude Code")
      [[ "$LANG_CODE" == "es" ]] \
        && echo "4. Escribe \`/agent ${output_filename}\` en Claude Code para activarlo" \
        || echo "4. Type \`/agent ${output_filename}\` in Claude Code to activate it" ;;
    "Cursor")
      [[ "$LANG_CODE" == "es" ]] \
        && echo "4. El archivo \`.cursor/rules/${output_filename}.md\` se aplica automáticamente en Cursor" \
        || echo "4. The file \`.cursor/rules/${output_filename}.md\` is applied automatically in Cursor" ;;
    "Devin")
      [[ "$LANG_CODE" == "es" ]] \
        && echo "4. Pega el contenido en el campo de instrucciones al iniciar una sesión de Devin" \
        || echo "4. Paste the content in the instructions field when starting a Devin session" ;;
    "Windsurf")
      [[ "$LANG_CODE" == "es" ]] \
        && echo "4. El archivo \`.windsurf/rules/${output_filename}.md\` se aplica automáticamente en Windsurf" \
        || echo "4. The file \`.windsurf/rules/${output_filename}.md\` is applied automatically in Windsurf" ;;
    "Gemini CLI")
      [[ "$LANG_CODE" == "es" ]] \
        && echo "4. Usa: \`gemini --context ${output_filename}.md\` para activar el agente" \
        || echo "4. Use: \`gemini --context ${output_filename}.md\` to activate the agent" ;;
    "OpenAI Codex")
      if [[ "$codex_agents_md" == true ]]; then
        [[ "$LANG_CODE" == "es" ]] \
          && echo "4. Codex detecta \`AGENTS.md\` automáticamente — no necesitas ningún flag" \
          || echo "4. Codex detects \`AGENTS.md\` automatically — no flag needed"
      else
        [[ "$LANG_CODE" == "es" ]] \
          && echo "4. Usa: \`codex --system-prompt ${output_filename}.md\` para activar el agente" \
          || echo "4. Use: \`codex --system-prompt ${output_filename}.md\` to activate the agent"
      fi ;;
    "Aider")
      [[ "$LANG_CODE" == "es" ]] \
        && echo "4. Usa: \`aider --system-prompt ${output_filename}.md\` para activar el agente" \
        || echo "4. Use: \`aider --system-prompt ${output_filename}.md\` to activate the agent" ;;
  esac
}

show_summary() {
  echo ""
  echo -e "${CYAN}${BOLD}──────────────────────────────────────────────────────${RESET}"
  echo -e "${BOLD}${MSG_NEXT_STEPS}${RESET}"
  echo -e "  ${MSG_STEP1}"
  echo -e "  ${MSG_STEP2}"
  echo -e "  ${MSG_STEP3}"
  echo -e "  $(get_activation_step)"
  echo -e "${CYAN}${BOLD}──────────────────────────────────────────────────────${RESET}"
  echo ""
  echo -e "  ${GREEN}${BOLD}${MSG_THANKS}${RESET}"
  echo ""
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  # Global state
  LANG_CODE="en"
  agent_name=""
  agent_description=""
  agent_objective=""
  agent_role=""
  agent_model=""
  agent_platform=""
  agent_color=""
  agent_tools=""
  agent_mcp_tools=""
  agent_behavior=""
  agent_constraints=""
  output_filename=""
  auto_place=false
  agent_installed_skill=""
  cursor_always_apply=false
  cursor_globs=""
  codex_agents_md=false
  devin_playbook=false
  devin_trigger=""

  print_header
  select_language
  load_strings

  echo ""
  echo -e "${GREEN}${MSG_WELCOME}${RESET}"

  # ── Step 1: Identity ────────────────────────────────────────────────────────
  print_step "1" "$MSG_STEP_IDENTITY"

  ask agent_name "$MSG_AGENT_NAME"
  agent_name=$(echo "$agent_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-_')

  echo ""
  print_info "$MSG_AGENT_DESC_TIP"
  ask agent_description "$MSG_AGENT_DESC"

  echo ""
  ask agent_objective "$MSG_AGENT_OBJ"

  # ── Skill Discovery (between identity and model) ─────────────────────────────
  echo ""
  discover_skills

  echo ""
  ask_choice_with_desc agent_role "$MSG_AGENT_ROLE" \
    "$ROLE_OPT_ORCH" \
    "$ROLE_OPT_WORK" \
    "$ROLE_OPT_SPEC" \
    "$ROLE_OPT_GEN"

  # ── Step 2: Platform ────────────────────────────────────────────────────────
  print_step "2" "$MSG_STEP_PLATFORM"

  ask_choice agent_platform "$MSG_PLATFORM" \
    "Claude Code" "Cursor" "Devin" "Windsurf" "Gemini CLI" "OpenAI Codex" "Aider"

  # ── Step 3: Model + Color (Claude Code only) ─────────────────────────────────
  if [[ "$agent_platform" == "Claude Code" ]]; then
    print_step "3" "$MSG_STEP_MODEL"

    ask_choice_with_desc agent_model "$MSG_MODEL_SELECT" \
      "claude-sonnet-4-6|${MSG_MODEL_SONNET}" \
      "claude-opus-4-8|${MSG_MODEL_OPUS}" \
      "claude-haiku-4-5-20251001|${MSG_MODEL_HAIKU}"

    echo ""
    ask_choice agent_color "$MSG_COLOR_SELECT" \
      "blue" "green" "yellow" "orange" "red" "purple" "cyan" "pink"
  fi

  # Platform-specific config (Cursor globs, Devin format, Codex AGENTS.md)
  gather_platform_config

  # ── Step 4: Tools ───────────────────────────────────────────────────────────
  print_step "4" "$MSG_STEP_TOOLS"

  if [[ "$agent_platform" == "Claude Code" ]]; then
    ask_multiselect agent_tools "$MSG_TOOLS_CLAUDE" \
      "$TOOL_READ" "$TOOL_WRITE" "$TOOL_EDIT" "$TOOL_BASH" "$TOOL_GLOB" "$TOOL_GREP" \
      "$TOOL_WEBSEARCH" "$TOOL_WEBFETCH" "$TOOL_TASK" "$TOOL_TODOWRITE" "$TOOL_NOTEBOOKEDIT"
  else
    ask_multiselect agent_tools "$MSG_TOOLS_GENERIC" \
      "Read files" \
      "Write files" \
      "Execute shell commands" \
      "Search the web" \
      "Call external APIs" \
      "Read and write databases" \
      "Manage Git repositories" \
      "Analyze images" \
      "Send messages/notifications" \
      "Custom tool"
  fi

  # MCP tools (optional)
  echo ""
  if confirm "$MSG_MCP_CONFIRM"; then
    ask agent_mcp_tools "$MSG_MCP_NAMES"
  fi

  # ── Step 5: Behavior ────────────────────────────────────────────────────────
  print_step "5" "$MSG_STEP_BEHAVIOR"

  ask agent_behavior "$MSG_BEHAVIOR"
  echo ""
  ask agent_constraints "$MSG_CONSTRAINTS"

  # ── Step 6: Output ──────────────────────────────────────────────────────────
  print_step "6" "$MSG_STEP_OUTPUT"

  echo ""
  print_info "$MSG_OUTPUT_FILE_TIP"
  ask_default output_filename "$MSG_OUTPUT_FILE" "$agent_name"
  output_filename=$(echo "$output_filename" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-_')
  [[ -z "$output_filename" ]] && output_filename="$agent_name"

  # Auto-place: platforms with a standard directory
  local _autoplace_path="" _autoplace_tip=""
  case "$agent_platform" in
    "Claude Code")
      _autoplace_path=".claude/agents/${output_filename}.md"
      if [[ "$LANG_CODE" == "es" ]]; then
        _autoplace_tip="Recomendado: di sí para usar /agent ${output_filename} en Claude Code"
      else
        _autoplace_tip="Recommended: say yes to use /agent ${output_filename} in Claude Code"
      fi ;;
    "Cursor")
      _autoplace_path=".cursor/rules/${output_filename}.md"
      if [[ "$LANG_CODE" == "es" ]]; then
        _autoplace_tip="Recomendado: di sí para que Cursor aplique la regla automáticamente"
      else
        _autoplace_tip="Recommended: say yes so Cursor applies the rule automatically"
      fi ;;
    "Windsurf")
      _autoplace_path=".windsurf/rules/${output_filename}.md"
      if [[ "$LANG_CODE" == "es" ]]; then
        _autoplace_tip="Recomendado: di sí para que Windsurf detecte la regla automáticamente"
      else
        _autoplace_tip="Recommended: say yes so Windsurf detects the rule automatically"
      fi ;;
    "Devin")
      if [[ "$devin_playbook" == true ]]; then
        _autoplace_path=".devin/playbooks/${output_filename}.md"
        if [[ "$LANG_CODE" == "es" ]]; then
          _autoplace_tip="Recomendado: di sí para guardar el playbook donde Devin lo detecta"
        else
          _autoplace_tip="Recommended: say yes to save the playbook where Devin detects it"
        fi
      fi ;;
  esac

  if [[ -n "$_autoplace_path" ]]; then
    echo ""
    print_info "$_autoplace_path"
    print_info "$_autoplace_tip"
    if confirm_yes "$MSG_AUTO_PLACE"; then
      auto_place=true
    fi
  fi

  # ── Generate ────────────────────────────────────────────────────────────────
  echo ""
  echo -e "${BLUE}${BOLD}${MSG_GENERATING}${RESET}"
  generate_agent_file

  # ── Install ─────────────────────────────────────────────────────────────────
  echo ""
  if confirm "$MSG_INSTALL_PROMPT"; then
    run_install
  fi

  # ── Summary ─────────────────────────────────────────────────────────────────
  load_strings  # refresh so MSG_STEP4 uses the real agent_name
  show_summary
}

main "$@"
