# What is an AI Agent?

An **AI agent** is a program that uses a language model (like Claude, GPT-4, or Gemini) as its "brain" — giving it the ability to understand goals, reason about how to achieve them, and take real actions in the world.

Unlike a simple chatbot that only responds to questions, an agent can:

- **Plan** — break a complex task into steps
- **Act** — execute those steps using tools (run code, read files, search the web, call APIs)
- **Observe** — look at the results of each action
- **Adapt** — change its plan based on what it finds

---

## A Simple Analogy

Think of a traditional chatbot as a very smart encyclopedia — it can answer questions, but it can't *do* anything.

An AI agent is more like a skilled assistant with a to-do list, a set of tools, and the authority to get things done. You give it a goal; it figures out the steps, does the work, and reports back.

---

## The Core Loop

Every agent runs the same basic loop:

```
Receive goal
  ↓
Think: what's the best next action?
  ↓
Act: use a tool (read file, run command, search web...)
  ↓
Observe: what happened?
  ↓
Think again... → Act again... → (repeat until done)
  ↓
Report result
```

This loop is called the **ReAct loop** (Reasoning + Acting), and it's the foundation of virtually every AI agent system today.

---

## What Makes an Agent Different from a Chatbot?

| Feature | Chatbot | Agent |
|---|---|---|
| Holds a conversation | ✅ | ✅ |
| Takes actions (run code, write files) | ❌ | ✅ |
| Plans multi-step tasks | ❌ | ✅ |
| Uses external tools | ❌ | ✅ |
| Works autonomously | ❌ | ✅ |
| Can be interrupted and guided | ✅ | ✅ |

---

## Components of an Agent

An agent definition (like the `.md` files in this repo) typically specifies:

1. **Name** — What to call it
2. **Objective** — What goal is it working toward?
3. **Tools** — What can it do? (read files, search web, run shell commands, etc.)
4. **Behavior** — How should it communicate and prioritize?
5. **Constraints** — What must it never do?
6. **Output format** — How should it structure its answers?

---

## Real-World Examples

- **Coding agent** — Reads your codebase, writes new features, runs tests, fixes bugs
- **Research agent** — Searches the web, reads documents, synthesizes a report
- **DevOps agent** — Monitors infrastructure, runs deployments, alerts on failures
- **Personal assistant** — Manages your calendar, summarizes emails, drafts messages

---

## Further Reading

- [How It Works](how-it-works.md) — The technical flow step by step
- [Model Comparison](model-comparison.md) — Which model to choose for your agent
- [Base Template](../../templates/base-agent.md) — Build your own agent now
