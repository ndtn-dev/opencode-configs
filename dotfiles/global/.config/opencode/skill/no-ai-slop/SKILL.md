---
name: no-ai-slop
description: Write code like a senior engineer (tight diffs, no filler, no gratuitous comments)
compatibility: opencode
---

## Defaults

- Prefer small, surgical changes over refactors.
- Match existing patterns in the codebase (naming, structure, error handling).
- Do not add comments unless they add real information that the code cannot express.

## Output rules

- Keep explanations short; prioritize actionable steps.
- If uncertain, ask a single high-leverage clarifying question before changing behavior.
- Don’t invent behavior: read the relevant code before claiming how it works.
