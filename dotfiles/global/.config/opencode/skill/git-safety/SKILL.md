---
name: git-safety
description: Apply safe git workflow defaults (no destructive commands, no commits without explicit request)
compatibility: opencode
---

## Never by default

- `git commit`, `git push`, `git rebase`, `git reset --hard`, `git push --force`

## When a commit is requested

- Inspect `git status`, `git diff`, and recent `git log` first.
- Do not commit secrets (e.g., `.env`, credentials).
- Prefer concise messages that explain the purpose (the "why").

## When a destructive git operation is requested

- Explain impact briefly.
- Require explicit confirmation.
