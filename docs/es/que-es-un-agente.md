# ¿Qué es un Agente de IA?

Un **agente de IA** es un programa que usa un modelo de lenguaje (como Claude, GPT-4 o Gemini) como su "cerebro" — dándole la capacidad de entender objetivos, razonar sobre cómo alcanzarlos y tomar acciones reales en el mundo.

A diferencia de un chatbot simple que solo responde preguntas, un agente puede:

- **Planificar** — dividir una tarea compleja en pasos
- **Actuar** — ejecutar esos pasos usando herramientas (ejecutar código, leer archivos, buscar en la web, llamar APIs)
- **Observar** — ver los resultados de cada acción
- **Adaptarse** — cambiar su plan según lo que encuentra

---

## Una Analogía Simple

Piensa en un chatbot tradicional como una enciclopedia muy inteligente: puede responder preguntas, pero no puede *hacer* nada.

Un agente de IA es más como un asistente habilidoso con una lista de tareas, un conjunto de herramientas y la autoridad para hacer el trabajo. Le das un objetivo; él descifra los pasos, hace el trabajo y te informa.

---

## El Ciclo Central

Cada agente ejecuta el mismo ciclo básico:

```
Recibir objetivo
  ↓
Pensar: ¿cuál es la mejor acción siguiente?
  ↓
Actuar: usar una herramienta (leer archivo, ejecutar comando, buscar web...)
  ↓
Observar: ¿qué pasó?
  ↓
Pensar de nuevo... → Actuar de nuevo... → (repetir hasta terminar)
  ↓
Reportar resultado
```

Este ciclo se llama el **ciclo ReAct** (Razonamiento + Acción), y es la base de prácticamente todo sistema de agente de IA en la actualidad.

---

## ¿Qué Diferencia un Agente de un Chatbot?

| Característica | Chatbot | Agente |
|---|---|---|
| Mantiene conversación | ✅ | ✅ |
| Toma acciones (ejecuta código, escribe archivos) | ❌ | ✅ |
| Planifica tareas de múltiples pasos | ❌ | ✅ |
| Usa herramientas externas | ❌ | ✅ |
| Trabaja de forma autónoma | ❌ | ✅ |
| Puede ser interrumpido y guiado | ✅ | ✅ |

---

## Componentes de un Agente

La definición de un agente (como los archivos `.md` en este repo) típicamente especifica:

1. **Nombre** — Cómo llamarlo
2. **Objetivo** — ¿Hacia qué meta está trabajando?
3. **Herramientas** — ¿Qué puede hacer? (leer archivos, buscar web, ejecutar comandos, etc.)
4. **Comportamiento** — ¿Cómo debe comunicarse y priorizar?
5. **Restricciones** — ¿Qué no debe hacer jamás?
6. **Formato de salida** — ¿Cómo debe estructurar sus respuestas?

---

## Ejemplos del Mundo Real

- **Agente de código** — Lee tu código, escribe nuevas funciones, ejecuta pruebas, corrige errores
- **Agente de investigación** — Busca en la web, lee documentos, sintetiza un reporte
- **Agente DevOps** — Monitorea infraestructura, ejecuta despliegues, envía alertas
- **Asistente personal** — Gestiona tu calendario, resume correos, redacta mensajes

---

## Lectura Adicional

- [Cómo Funciona](como-funciona.md) — El flujo técnico paso a paso
- [Comparativa de Modelos](comparativa-modelos.md) — Qué modelo elegir para tu agente
- [Plantilla Base](../../templates/base-agent.md) — Construye tu propio agente ahora
