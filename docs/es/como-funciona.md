# Cómo Funciona

Esta página explica el flujo técnico detrás de `create-agent.sh` y cómo los archivos de agente generados son usados por cada plataforma soportada.

---

## El Flujo de Create-Agent

Cuando ejecutas `./create-agent.sh`, te guía a través de seis pasos:

```
Paso 0: Elige tu idioma (English / Español)
   ↓
Paso 1: Identidad del Agente
        • Nombre (kebab-case)
        • Descripción (campo frontmatter — usado para invocar el agente)
        • Objetivo principal
        • Tipo de rol: Orquestador / Trabajador / Especialista / General
   ↓
Paso 2: Selección de Modelo
        • sonnet — código y tareas generales (recomendado)
        • opus   — razonamiento profundo, orquestación
        • haiku  — tareas ligeras, alto volumen
   ↓
Paso 3: Plataforma Objetivo
        (Claude Code, Cursor, Devin, Windsurf, Gemini CLI, Codex, Aider)
        + Selector de color para el ícono en Claude Code
   ↓
Paso 4: Herramientas del Agente
        • Claude Code: nombres oficiales (Read, Write, Bash, WebSearch…)
        • Otras plataformas: categorías genéricas de herramientas
        + Opcional: herramientas MCP externas
   ↓
Paso 5: Comportamiento y Restricciones
        • Estilo de comportamiento
        • Restricciones duras (lo que jamás debe hacer)
   ↓
Paso 6: Archivo de Salida
        • Nombre del archivo
        • Auto-colocar en .claude/agents/ (solo Claude Code)
   ↓
   Generar → Opcionalmente ejecutar el script de instalación
```

El resultado es un archivo Markdown con frontmatter YAML oficial que Claude Code lee de forma nativa, más un prompt de sistema estructurado que define el rol, proceso, comportamiento y formato de salida del agente.

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

### Claude Code (especificación oficial)

Para Claude Code, el script genera el formato oficial de agente — el mismo usado por todos los agentes de producción:

```markdown
---
name: mi-agente
description: Experto en X. Usar PROACTIVAMENTE cuando necesites...
model: sonnet
tools: ["Read", "Write", "Bash"]
color: blue
---

Eres mi-agente, un experto en X.

## Tu Rol

- Lo que hace este agente (lista de puntos)

## Objetivo

Lo que intenta lograr.

## Proceso

Al recibir una tarea:
1. Paso uno
2. Paso dos

## Comportamiento

- Cómo debe actuar

## Restricciones

- Lo que jamás debe hacer

## Formato de Salida

- Cómo estructurar las respuestas
```

El **frontmatter** es leído por Claude Code para registrar el agente y configurar su modelo y herramientas. El **cuerpo** es el prompt del sistema — lo que el modelo de IA realmente lee y sigue.

### Otras Plataformas

Para Cursor, Windsurf, Gemini CLI, Codex y Aider, el script genera un prompt de sistema Markdown genérico con una sección de `Instrucciones de Plataforma` al final.

### Campos clave del frontmatter

| Campo | Requerido | Descripción |
|-------|-----------|-------------|
| `name` | Sí | Identificador del agente en kebab-case |
| `description` | Sí | Qué hace + cuándo invocarlo |
| `model` | No | `sonnet` \| `opus` \| `haiku` |
| `tools` | No | Array JSON de herramientas permitidas |
| `color` | No | Color del ícono en la UI de Claude Code |

---

## Siguientes Pasos

- [¿Qué es un Agente?](que-es-un-agente.md)
- [Comparativa de Modelos](comparativa-modelos.md)
- [Plantillas](../../templates/) — Explora agentes de ejemplo
