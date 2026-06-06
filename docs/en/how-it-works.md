# How It Works

This page explains the technical flow behind `create-agent.sh` and how the generated agent files are used by each supported platform.

---

## The Create-Agent Flow

When you run `./create-agent.sh`, it walks you through six steps:

```
Step 0: Choose your language (English / Spanish)
   ↓
Step 1: Agent Identity
        • Name (kebab-case)
        • Description (frontmatter field — used to invoke the agent)
        • Main objective
        • Role type: Orchestrator / Worker / Specialist / General
   ↓
Step 2: Model Selection
        • sonnet — coding & general tasks (recommended)
        • opus   — deep reasoning, orchestration
        • haiku  — lightweight, high-volume tasks
   ↓
Step 3: Target Platform
        (Claude Code, Cursor, Devin, Windsurf, Gemini CLI, Codex, Aider)
        + Color picker for Claude Code icon
   ↓
Step 4: Agent Tools
        • Claude Code: official tool names (Read, Write, Bash, WebSearch…)
        • Other platforms: generic tool categories
        + Optional: MCP external tools
   ↓
Step 5: Behavior & Constraints
        • Behavior style
        • Hard constraints (what it must never do)
   ↓
Step 6: Output File
        • Output filename
        • Auto-place in .claude/agents/ (Claude Code only)
   ↓
   Generate → Optionally run install script
```

The output is a Markdown file with official YAML frontmatter that Claude Code reads natively, plus a structured system prompt that defines the agent's role, process, behavior, and output format.

---

## What is the Agent File?

The generated `.md` file is a **system prompt** formatted as Markdown. It tells the AI model:

- What role it's playing (name, description)
- What it's trying to accomplish (objective)
- What it's allowed to do (tools)
- How to behave (behavior guidelines)
- What to avoid (constraints)
- How to format responses (output format)

Every major AI coding platform reads these instructions at the start of a session and uses them to configure the model's behavior for that session.

---

## How Each Platform Uses the File

### Claude Code

Claude Code looks for agent files in `.claude/agents/` within your project.

```bash
.claude/
└── agents/
    └── my-agent.md    ← your generated file goes here
```

List available agents with `/agents` inside Claude Code. Activate with `/agent my-agent`.

### Cursor

Cursor uses "rules" — instructions embedded in `.cursor/rules/` or the global `.cursorrules` file.

```bash
.cursor/
└── rules/
    └── my-agent.md
```

Activate in Cursor Settings → Rules, or reference it directly in your Cursor chat.

### Windsurf

Windsurf uses "global rules" configured in Settings → Cascade.

```bash
.windsurf/
└── rules/
    └── my-agent.md
```

Or paste the content directly into Windsurf's global rules field.

### Devin

Devin is web-based. Paste your agent file content into the session system prompt field when starting a new Devin session.

### Gemini CLI

Pass your agent file as context when launching Gemini CLI:

```bash
gemini --context my-agent.md
```

Or place it in `~/.gemini/agents/` for persistent use.

### OpenAI Codex

Use your agent content as the system prompt when calling the Codex CLI or API:

```bash
codex --system-prompt my-agent.md
```

### Aider

Pass your agent as the system prompt:

```bash
aider --system-prompt my-agent.md
```

Or configure it in `.aider.conf.yml`:

```yaml
system-prompt: my-agent.md
```

---

## The Agent Markdown Format

### Claude Code (official spec)

For Claude Code, the script generates the official agent format used by all production agents:

```markdown
---
name: my-agent
description: Expert in X. Use PROACTIVELY when you need to...
model: sonnet
tools: ["Read", "Write", "Bash"]
color: blue
---

You are my-agent, an expert in X.

## Your Role

- What this agent does (bullet list)

## Objective

What it's trying to achieve.

## Process

When given a task:
1. Step one
2. Step two

## Behavior

- How it should act

## Constraints

- What it must never do

## Output Format

- How to structure responses
```

The **frontmatter** is read by Claude Code to register the agent and configure its model and tools. The **body** is the system prompt — what the AI actually reads and follows.

### Other Platforms

For Cursor, Windsurf, Gemini CLI, Codex, and Aider, the script generates a generic Markdown system prompt with a `Platform Instructions` section at the end.

### Key frontmatter fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Kebab-case agent identifier |
| `description` | Yes | What it does + when to invoke it |
| `model` | No | `sonnet` \| `opus` \| `haiku` |
| `tools` | No | JSON array of allowed tools |
| `color` | No | Icon color in Claude Code UI |

---

## Next Steps

- [What is an Agent?](what-is-an-agent.md)
- [Model Comparison](model-comparison.md)
- [Templates](../../templates/) — Browse example agents
