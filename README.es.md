# 🤖 Build Your Agent

> Una guía bilingüe y amigable para principiantes que te ayuda a crear tu primer agente de IA — compatible con Claude Code, Cursor, Devin, Windsurf, Gemini CLI, OpenAI Codex y Aider.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

**[🇺🇸 English Version](README.md)**

---

## ¿Qué es esto?

**Build Your Agent** es un toolkit de código abierto que ayuda a cualquier persona — sea desarrollador o no — a crear y desplegar un agente de IA personalizado en minutos. Un script interactivo hace el trabajo pesado: te hace unas pocas preguntas y genera un archivo de agente listo para usar en la plataforma que elijas.

## Plataformas Soportadas

| Plataforma | Descripción |
|---|---|
| [Claude Code](https://claude.ai/code) | Agente de código CLI de Anthropic |
| [Cursor](https://cursor.sh) | Editor de código con IA integrada |
| [Devin](https://devin.ai) | Agente autónomo de ingeniería de software |
| [Windsurf](https://codeium.com/windsurf) | IDE con IA de Codeium |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | Agente de terminal de Google |
| [OpenAI Codex](https://openai.com/blog/openai-codex) | CLI del modelo de código de OpenAI |
| [Aider](https://aider.chat) | Programación en pareja con IA en tu terminal |

---

## Inicio Rápido

> **Primero, abre una terminal en tu sistema operativo:**
> - **macOS** — Presiona `⌘ Espacio`, escribe **Terminal**, presiona Enter
> - **Linux** — Presiona `Ctrl + Alt + T` o busca **Terminal** en el lanzador de apps
> - **Windows** — Presiona `Win + X` → **Windows Terminal**, o instala [Git Bash](https://git-scm.com/downloads) y ábrelo
>
> En Windows, usa **Git Bash** o **WSL** para ejecutar los comandos de abajo.

```bash
curl -fsSL https://raw.githubusercontent.com/crexative/build-your-agent/main/install.sh | bash
```

O clona y ejecuta manualmente:

```bash
git clone https://github.com/crexative/build-your-agent.git
cd build-your-agent
chmod +x create-agent.sh
./create-agent.sh
```

El script hará lo siguiente:
1. Te pedirá elegir un idioma (English / Español)
2. Preguntará el nombre y objetivo de tu agente
3. Te permitirá seleccionar las herramientas que puede usar
4. Preguntará en qué plataforma quieres desplegarlo
5. Generará un archivo `.md` listo para usar como agente
6. Opcionalmente ejecutará el script de instalación para la plataforma elegida

---

## ¿Qué es un Agente de IA?

Un agente de IA es un sistema que usa un modelo de lenguaje (como Claude, GPT-4 o Gemini) para **entender objetivos, planificar pasos y tomar acciones** — como leer archivos, ejecutar código, buscar en la web o llamar APIs — para completar tareas de forma autónoma.

Piénsalo como darle a una IA un título de trabajo, un conjunto de herramientas y la autoridad para hacer las cosas.

👉 Lee más: [¿Qué es un Agente?](docs/es/que-es-un-agente.md)

---

## Estructura del Proyecto

```
build-your-agent/
├── README.md                  # Versión en inglés
├── README.es.md               # Este archivo (Español)
├── create-agent.sh            # Guía CLI interactiva
├── templates/
│   ├── base-agent.md          # Plantilla base para cualquier agente
│   └── examples/
│       ├── assistant.md       # Agente asistente personal
│       ├── researcher.md      # Agente investigador
│       └── coder.md           # Agente de programación
├── install/
│   ├── claude-code.sh         # Instalación de Claude Code
│   ├── cursor.sh              # Instalación de Cursor
│   ├── devin.sh               # Instalación de Devin
│   ├── windsurf.sh            # Instalación de Windsurf
│   ├── gemini-cli.sh          # Instalación de Gemini CLI
│   ├── codex.sh               # Instalación de OpenAI Codex
│   └── aider.sh               # Instalación de Aider
├── docs/
│   ├── en/                    # Documentación en inglés
│   └── es/                    # Documentación en español
│       ├── que-es-un-agente.md
│       ├── como-funciona.md
│       └── comparativa-modelos.md
└── CONTRIBUTING.md
```

---

## Plantillas

Se incluyen tres ejemplos de agentes listos para usar:

- **[Asistente](templates/examples/assistant.md)** — Un asistente personal de propósito general
- **[Investigador](templates/examples/researcher.md)** — Un agente que recopila y sintetiza información
- **[Programador](templates/examples/coder.md)** — Un agente enfocado en desarrollo de software

O comienza desde la **[plantilla base](templates/base-agent.md)** y personalízala tú mismo.

---

## Documentación

| Español | English |
|---|---|
| [¿Qué es un Agente?](docs/es/que-es-un-agente.md) | [What is an Agent?](docs/en/what-is-an-agent.md) |
| [Cómo Funciona](docs/es/como-funciona.md) | [How It Works](docs/en/how-it-works.md) |
| [Comparativa de Modelos](docs/es/comparativa-modelos.md) | [Model Comparison](docs/en/model-comparison.md) |

---

## Contribuir

¡Damos la bienvenida a todo tipo de contribuciones — nuevas plantillas, soporte para nuevas plataformas, traducciones, mejoras de documentación y corrección de errores!

Lee [CONTRIBUTING.md](CONTRIBUTING.md) para comenzar.

---

## Licencia

MIT — libre para usar, modificar y distribuir. Consulta [LICENSE](LICENSE) para más detalles.

---

## Inspiración

Este proyecto fue inspirado por [agency-agents](https://github.com/msitarzewski/agency-agents) de msitarzewski. Construido con la convicción de que los agentes de IA deben ser accesibles para todos.
