# How It Works

This page explains the technical flow behind `create-agent.sh` and how the generated agent files are used by each supported platform.

---

## The Create-Agent Flow

When you run `./create-agent.sh`, it walks you through five steps:

```
Step 1: Choose your language (English / Spanish)
   ↓
Step 2: Define your agent
        • Name
        • Description
        • Objective
        • Tools it can use
        • Behavior guidelines
        • Constraints
   ↓
Step 3: Choose your target platform
        (Claude Code, Cursor, Devin, Windsurf, Gemini CLI, Codex, Aider)
   ↓
Step 4: Generate a ready-to-use .md agent file
   ↓
Step 5: Optionally run the platform install script
```

The output is a single Markdown file that contains a structured system prompt — essentially, instructions for the AI about who it is and how to behave.

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

```markdown
---
name: my-agent
platform: Claude Code
language: en
created: 2025-01-01
---

# Agent: my-agent

## Description
...

## Objective
...

## Available Tools
...

## Behavior
...

## Constraints
...

## Output Format
...
```

The frontmatter (`---` block) is optional metadata. The headings are what the AI model actually reads.

---

## Next Steps

- [What is an Agent?](what-is-an-agent.md)
- [Model Comparison](model-comparison.md)
- [Templates](../../templates/) — Browse example agents
