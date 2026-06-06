# Model Comparison

Choosing the right model for your agent is one of the most important decisions you'll make. This guide compares the leading models across the dimensions that matter most for agent use cases.

---

## Quick Reference

| Model | Provider | Best For | Context | Speed | Cost |
|---|---|---|---|---|---|
| Claude Opus 4 | Anthropic | Deep reasoning, complex tasks | 200K | Moderate | $$$ |
| Claude Sonnet 4 | Anthropic | Coding, general agents | 200K | Fast | $$ |
| Claude Haiku 4 | Anthropic | High-volume, lightweight tasks | 200K | Very fast | $ |
| GPT-4o | OpenAI | Multimodal, general purpose | 128K | Fast | $$ |
| GPT-4o mini | OpenAI | Budget-friendly tasks | 128K | Very fast | $ |
| Gemini 2.0 Flash | Google | Speed-optimized agents | 1M | Very fast | $ |
| Gemini 2.0 Pro | Google | Long-context, reasoning | 2M | Moderate | $$$ |

*Cost is relative: $ = low, $$ = medium, $$$ = high. Always check current pricing at provider websites.*

---

## Anthropic Claude

**Best for**: Coding agents, instruction-following, complex reasoning

Claude models are particularly strong at:
- Following detailed system prompts reliably
- Multi-step coding and debugging tasks
- Long-context document analysis
- Safety and constraint adherence

**Recommended model by use case:**

| Use Case | Recommended |
|---|---|
| Coding agent (main work) | Claude Sonnet 4 |
| Orchestrator / architect | Claude Opus 4 |
| High-volume worker agents | Claude Haiku 4 |
| Research & analysis | Claude Opus 4 |

**Platform support**: Claude Code (native), Cursor, Windsurf, Aider, Devin

---

## OpenAI GPT-4o

**Best for**: Multimodal tasks, vision, general-purpose assistants

GPT-4o excels at:
- Analyzing images and screenshots
- General question answering
- Function calling and structured output
- Wide third-party tool ecosystem

**Platform support**: Codex (native), Cursor, Aider, Windsurf

---

## Google Gemini

**Best for**: Extremely long documents, high-speed tasks

Gemini's unique advantages:
- Largest context windows (up to 2M tokens)
- Fast inference at low cost
- Strong multimodal capabilities
- Tight integration with Google Workspace

**Platform support**: Gemini CLI (native), Cursor, Aider

---

## How to Choose

### For a coding agent
Start with **Claude Sonnet 4** — it has the best balance of code quality, instruction following, and cost.

### For a research agent
Use **Claude Opus 4** or **Gemini 2.0 Pro** — both handle long documents well, but Gemini wins on raw context length.

### For a high-volume personal assistant
Use **Claude Haiku 4** or **GPT-4o mini** — both are fast and cheap enough to run continuously without breaking the bank.

### For a multimodal agent (images, screenshots)
Use **GPT-4o** or **Gemini 2.0 Flash** — both have mature vision capabilities.

---

## Key Concepts

### Context Window
The maximum amount of text the model can read in a single request. A larger context window means the agent can process longer documents, larger codebases, and longer conversation histories without losing information.

### Tokens
Text is measured in tokens — roughly 3/4 of a word. A 100,000-token context window can hold about 75,000 words — approximately a 300-page book.

### Temperature
Controls randomness (0 = deterministic, 1 = creative). For coding agents, use 0–0.2. For creative assistants, use 0.7–1.0.

---

## Updating This Comparison

The AI model landscape changes rapidly. For the latest pricing and benchmarks, check:
- Anthropic: https://anthropic.com/pricing
- OpenAI: https://openai.com/pricing
- Google: https://ai.google.dev/pricing
- Independent benchmarks: https://lmsys.org/blog/2023-05-03-arena
