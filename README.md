# 🤖 Build Your Agent

> A beginner-friendly, bilingual guide to creating your first AI agent — compatible with Claude Code, Cursor, Devin, Windsurf, Gemini CLI, OpenAI Codex, and Aider.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

**[🇪🇸 Versión en Español](README.es.md)**

---

## What is this?

**Build Your Agent** is an open-source toolkit that helps anyone — developer or not — create and deploy a custom AI agent in minutes. One interactive script does the heavy lifting: it asks you a few questions and generates a ready-to-use agent file for your chosen platform.

## Supported Platforms

| Platform | Description |
|---|---|
| [Claude Code](https://claude.ai/code) | Anthropic's CLI coding agent |
| [Cursor](https://cursor.sh) | AI-first code editor |
| [Devin](https://devin.ai) | Autonomous software engineering agent |
| [Windsurf](https://codeium.com/windsurf) | AI-powered IDE by Codeium |
| [Gemini CLI](https://github.com/google-gemini/gemini-cli) | Google's terminal AI agent |
| [OpenAI Codex](https://openai.com/blog/openai-codex) | OpenAI's coding model CLI |
| [Aider](https://aider.chat) | AI pair programming in your terminal |

---

## Quick Start

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/build-your-agent.git
cd build-your-agent

# Make the script executable
chmod +x create-agent.sh

# Run the interactive guide
./create-agent.sh
```

The script will:
1. Ask you to choose a language (English / Spanish)
2. Ask your agent's name and objective
3. Let you select the tools your agent can use
4. Ask which platform you're targeting
5. Generate a ready-to-use `.md` agent file
6. Optionally run the install script for your chosen platform

---

## What is an AI Agent?

An AI agent is a system that uses a language model (like Claude, GPT-4, or Gemini) to **understand goals, plan steps, and take actions** — like reading files, running code, searching the web, or calling APIs — to complete a task autonomously.

Think of it as giving an AI a job title, a set of tools, and the authority to get things done.

👉 Read more: [What is an Agent?](docs/en/what-is-an-agent.md)

---

## Project Structure

```
build-your-agent/
├── README.md                  # This file (English)
├── README.es.md               # Spanish version
├── create-agent.sh            # Interactive CLI guide
├── templates/
│   ├── base-agent.md          # Base template for any agent
│   └── examples/
│       ├── assistant.md       # Personal assistant agent
│       ├── researcher.md      # Research agent
│       └── coder.md           # Coding agent
├── install/
│   ├── claude-code.sh         # Claude Code setup
│   ├── cursor.sh              # Cursor setup
│   ├── devin.sh               # Devin setup
│   ├── windsurf.sh            # Windsurf setup
│   ├── gemini-cli.sh          # Gemini CLI setup
│   ├── codex.sh               # OpenAI Codex setup
│   └── aider.sh               # Aider setup
├── docs/
│   ├── en/                    # English documentation
│   │   ├── what-is-an-agent.md
│   │   ├── how-it-works.md
│   │   └── model-comparison.md
│   └── es/                    # Spanish documentation
│       ├── que-es-un-agente.md
│       ├── como-funciona.md
│       └── comparativa-modelos.md
└── CONTRIBUTING.md
```

---

## Templates

Three ready-made agent examples are included to help you get started:

- **[Assistant](templates/examples/assistant.md)** — A general-purpose personal assistant
- **[Researcher](templates/examples/researcher.md)** — An agent that gathers and synthesizes information
- **[Coder](templates/examples/coder.md)** — A software development focused agent

Or start from the **[base template](templates/base-agent.md)** and customize it yourself.

---

## Documentation

| English | Español |
|---|---|
| [What is an Agent?](docs/en/what-is-an-agent.md) | [¿Qué es un Agente?](docs/es/que-es-un-agente.md) |
| [How It Works](docs/en/how-it-works.md) | [Cómo Funciona](docs/es/como-funciona.md) |
| [Model Comparison](docs/en/model-comparison.md) | [Comparativa de Modelos](docs/es/comparativa-modelos.md) |

---

## Contributing

We welcome contributions of all kinds — new templates, new platform support, translations, documentation improvements, and bug fixes.

See [CONTRIBUTING.md](CONTRIBUTING.md) to get started.

---

## License

MIT — free to use, modify, and distribute. See [LICENSE](LICENSE) for details.

---

## Inspiration

This project was inspired by [agency-agents](https://github.com/msitarzewski/agency-agents) by msitarzewski. Built with the belief that AI agents should be accessible to everyone.
