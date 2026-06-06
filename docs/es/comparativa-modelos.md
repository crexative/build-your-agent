# Comparativa de Modelos

Elegir el modelo correcto para tu agente es una de las decisiones más importantes que tomarás. Esta guía compara los modelos líderes en las dimensiones que más importan para casos de uso de agentes.

---

## Referencia Rápida

| Modelo | Proveedor | Mejor Para | Contexto | Velocidad | Costo |
|---|---|---|---|---|---|
| Claude Opus 4 | Anthropic | Razonamiento profundo, tareas complejas | 200K | Moderada | $$$ |
| Claude Sonnet 4 | Anthropic | Código, agentes generales | 200K | Rápida | $$ |
| Claude Haiku 4 | Anthropic | Tareas de alto volumen y livianas | 200K | Muy rápida | $ |
| GPT-4o | OpenAI | Multimodal, propósito general | 128K | Rápida | $$ |
| GPT-4o mini | OpenAI | Tareas económicas | 128K | Muy rápida | $ |
| Gemini 2.0 Flash | Google | Agentes optimizados para velocidad | 1M | Muy rápida | $ |
| Gemini 2.0 Pro | Google | Contexto largo, razonamiento | 2M | Moderada | $$$ |

*El costo es relativo: $ = bajo, $$ = medio, $$$ = alto. Siempre verifica los precios actuales en los sitios web de cada proveedor.*

---

## Anthropic Claude

**Mejor para**: Agentes de código, seguimiento de instrucciones, razonamiento complejo

Los modelos Claude son particularmente buenos en:
- Seguir prompts de sistema detallados de manera confiable
- Tareas de código y depuración de múltiples pasos
- Análisis de documentos con contexto largo
- Adherencia a seguridad y restricciones

**Modelo recomendado por caso de uso:**

| Caso de Uso | Recomendado |
|---|---|
| Agente de código (trabajo principal) | Claude Sonnet 4 |
| Orquestador / arquitecto | Claude Opus 4 |
| Agentes trabajadores de alto volumen | Claude Haiku 4 |
| Investigación y análisis | Claude Opus 4 |

**Soporte de plataformas**: Claude Code (nativo), Cursor, Windsurf, Aider, Devin

---

## OpenAI GPT-4o

**Mejor para**: Tareas multimodales, visión, asistentes de propósito general

GPT-4o sobresale en:
- Análisis de imágenes y capturas de pantalla
- Respuesta a preguntas generales
- Llamadas a funciones y salida estructurada
- Amplio ecosistema de herramientas de terceros

**Soporte de plataformas**: Codex (nativo), Cursor, Aider, Windsurf

---

## Google Gemini

**Mejor para**: Documentos extremadamente largos, tareas de alta velocidad

Ventajas únicas de Gemini:
- Las ventanas de contexto más grandes (hasta 2M tokens)
- Inferencia rápida a bajo costo
- Sólidas capacidades multimodales
- Integración estrecha con Google Workspace

**Soporte de plataformas**: Gemini CLI (nativo), Cursor, Aider

---

## Cómo Elegir

### Para un agente de código
Comienza con **Claude Sonnet 4** — tiene el mejor equilibrio de calidad de código, seguimiento de instrucciones y costo.

### Para un agente de investigación
Usa **Claude Opus 4** o **Gemini 2.0 Pro** — ambos manejan documentos largos bien, pero Gemini gana en longitud de contexto bruto.

### Para un asistente personal de alto volumen
Usa **Claude Haiku 4** o **GPT-4o mini** — ambos son suficientemente rápidos y económicos para ejecutarse continuamente.

### Para un agente multimodal (imágenes, capturas de pantalla)
Usa **GPT-4o** o **Gemini 2.0 Flash** — ambos tienen capacidades de visión maduras.

---

## Conceptos Clave

### Ventana de Contexto
La cantidad máxima de texto que el modelo puede leer en una sola solicitud. Una ventana de contexto más grande significa que el agente puede procesar documentos más largos, bases de código más grandes e historiales de conversación más largos sin perder información.

### Tokens
El texto se mide en tokens — aproximadamente 3/4 de una palabra. Una ventana de contexto de 100,000 tokens puede contener unas 75,000 palabras — aproximadamente un libro de 300 páginas.

### Temperatura
Controla la aleatoriedad (0 = determinista, 1 = creativo). Para agentes de código, usa 0–0.2. Para asistentes creativos, usa 0.7–1.0.

---

## Actualizando Esta Comparativa

El panorama de modelos de IA cambia rápidamente. Para los últimos precios y benchmarks, consulta:
- Anthropic: https://anthropic.com/pricing
- OpenAI: https://openai.com/pricing
- Google: https://ai.google.dev/pricing
