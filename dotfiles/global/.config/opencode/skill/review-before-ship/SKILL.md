---
name: review-before-ship
description: Run a quick pre-ship checklist (diagnostics, tests, formatting) for touched areas
compatibility: opencode
---

## Checklist

- Run the narrowest relevant checks first (unit tests / typecheck for touched packages).
- If available: run formatter/linter for changed files.
- Do not fix unrelated failures; report them as pre-existing.

## Evidence

- Prefer commands that produce clear, machine-checkable output (exit code 0).
- If checks can’t be run, state what would be run locally.
