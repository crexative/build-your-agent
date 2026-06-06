# Cómo Funciona

Esta página explica el flujo técnico detrás de `create-agent.sh` y cómo los archivos de agente generados son usados por cada plataforma soportada.

---

## El Flujo de Create-Agent

Cuando ejecutas `./create-agent.sh`, te guía a través de cinco pasos:

```
Paso 1: Elige tu idioma (English / Español)
   ↓
Paso 2: Define tu agente
        • Nombre
        • Descripción
        • Objetivo
        • Herramientas que puede usar
        • Guías de comportamiento
        • Restricciones
   ↓
Paso 3: Elige tu plataforma objetivo
        (Claude Code, Cursor, Devin, Windsurf, Gemini CLI, Codex, Aider)
   ↓
Paso 4: Genera un archivo de agente .md listo para usar
   ↓
Paso 5: Opcionalmente ejecuta el script de instalación de la plataforma
```

El resultado es un único archivo Markdown que contiene un prompt de sistema estructurado — esencialmente, instrucciones para el modelo de IA sobre quién es y cómo comportarse.

---

## ¿Qué es el Archivo de Agente?

El archivo `.md` generado es un **prompt de sistema** formateado como Markdown. Le dice al modelo de IA:

- Qué rol está desempeñando (nombre, descripción)
- Qué está intentando lograr (objetivo)
- Qué le está permitido hacer (herramientas)
- Cómo comportarse (guías de comportamiento)
- Qué evitar (restricciones)
- Cómo formatear respuestas (formato de salida)

Cada plataforma principal de IA lee estas instrucciones al inicio de una sesión y las usa para configurar el comportamiento del modelo en esa sesión.

---

## Cómo Cada Plataforma Usa el Archivo

### Claude Code

Claude Code busca archivos de agente en `.claude/agents/` dentro de tu proyecto.

```bash
.claude/
└── agents/
    └── mi-agente.md    ← tu archivo generado va aquí
```

Lista los agentes disponibles con `/agents` dentro de Claude Code. Actívalo con `/agent mi-agente`.

### Cursor

Cursor usa "rules" (reglas) — instrucciones almacenadas en `.cursor/rules/` o el archivo global `.cursorrules`.

```bash
.cursor/
└── rules/
    └── mi-agente.md
```

Actívalo en Configuración de Cursor → Rules, o refiérelo directamente en el chat de Cursor.

### Windsurf

Windsurf usa "global rules" configuradas en Configuración → Cascade.

```bash
.windsurf/
└── rules/
    └── mi-agente.md
```

O pega el contenido directamente en el campo de reglas globales de Windsurf.

### Devin

Devin es basado en web. Pega el contenido de tu archivo de agente en el campo de prompt del sistema al iniciar una nueva sesión de Devin.

### Gemini CLI

Pasa tu archivo de agente como contexto al lanzar Gemini CLI:

```bash
gemini --context mi-agente.md
```

O colócalo en `~/.gemini/agents/` para uso persistente.

### OpenAI Codex

Usa tu contenido de agente como prompt del sistema:

```bash
codex --system-prompt mi-agente.md
```

### Aider

Pasa tu agente como prompt del sistema:

```bash
aider --system-prompt mi-agente.md
```

O configúralo en `.aider.conf.yml`:

```yaml
system-prompt: mi-agente.md
```

---

## El Formato Markdown del Agente

```markdown
---
name: mi-agente
platform: Claude Code
language: es
created: 2025-01-01
---

# Agent: mi-agente

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

El frontmatter (bloque `---`) es metadatos opcionales. Los encabezados son lo que el modelo de IA realmente lee.

---

## Siguientes Pasos

- [¿Qué es un Agente?](que-es-un-agente.md)
- [Comparativa de Modelos](comparativa-modelos.md)
- [Plantillas](../../templates/) — Explora agentes de ejemplo
