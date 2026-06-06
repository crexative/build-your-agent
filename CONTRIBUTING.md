# Contributing to Build Your Agent

Thank you for your interest in contributing! This project welcomes contributions from developers and non-developers alike.

## Ways to Contribute

- **New agent templates** — Add examples in `templates/examples/`
- **New platform support** — Add install scripts in `install/` and update the README
- **Translations** — Improve or add language support in `docs/`
- **Documentation** — Fix errors, improve clarity, add examples
- **Bug reports** — Open an issue describing what went wrong
- **Feature requests** — Open an issue with your idea

---

## Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/crexative/build-your-agent.git
   cd build-your-agent
   ```
3. Create a branch for your change:
   ```bash
   git checkout -b feat/my-new-feature
   ```
4. Make your changes
5. Test the script locally:
   ```bash
   chmod +x create-agent.sh
   ./create-agent.sh
   ```
6. Commit using conventional commits:
   ```
   feat: add support for platform X
   fix: correct variable in create-agent.sh
   docs: improve Spanish translation
   ```
7. Push and open a Pull Request

---

## Adding a New Platform

To add support for a new AI coding tool:

1. Create `install/<platform>.sh` following the pattern of existing install scripts
2. Add a case block in `create-agent.sh` under the platform selection menu
3. Add a row to the platform table in both `README.md` and `README.es.md`
4. Test the full flow end to end

---

## Adding a New Agent Template

1. Copy `templates/base-agent.md` and rename it under `templates/examples/`
2. Fill in all sections with a clear, focused agent definition
3. Add a link to the new template in both README files

---

## Style Guidelines

### Shell Scripts

- Use `#!/usr/bin/env bash` as the shebang
- Use `set -euo pipefail` for safety
- Quote all variables: `"$VAR"` not `$VAR`
- Use lowercase variable names
- Add a comment explaining non-obvious logic

### Markdown

- Use ATX-style headings (`## Heading`, not underline style)
- Wrap code in fenced code blocks with language hints
- Keep lines under 120 characters where practical
- Every new platform or template section should have a short description

### Agent Template Files

Follow the structure in `templates/base-agent.md`:
- `name` — Short, memorable name
- `description` — One-line summary
- `objective` — What the agent is trying to accomplish
- `tools` — Comma-separated list of capabilities
- `behavior` — How the agent should act and prioritize
- `constraints` — What the agent must NOT do
- `output_format` — How the agent should format its responses

---

## Commit Message Format

```
<type>: <short description>

[optional body]
```

Types: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`

---

## Code of Conduct

Be kind, inclusive, and constructive. This project is for everyone — beginners welcome.

---

## Questions?

Open an issue or start a discussion in the GitHub Discussions tab.
