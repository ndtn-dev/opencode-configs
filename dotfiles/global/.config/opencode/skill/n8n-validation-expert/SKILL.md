---
name: n8n-validation-expert
description: Interpret and fix n8n validation errors/warnings; choose profiles; use validate_node/validate_workflow loops.
license: MIT
compatibility: opencode
metadata:
  category: n8n
  triggers: validate, validation, errors, warnings, profile, runtime, ai-friendly, strict
---

# n8n Validation Expert

Use this when validation fails or you need to prevent deploy-time surprises.

Source: adapted from `czlonkowski/n8n-skills` for OpenCode.

## The Validation Loop

Expect iteration:
1) configure -> 2) validate -> 3) fix -> repeat (usually 2-3 cycles).

## Profiles

- `minimal`: required fields only (fast)
- `runtime`: recommended default (balanced)
- `ai-friendly`: reduce noisy warnings for AI-generated configs
- `strict`: production-hardening (can be noisy)

## Common Error Classes

- missing required fields
- invalid option values
- type mismatch
- invalid expression
- invalid references (node names / missing nodes)

## Workflow-Level Validation

- Use `validate_workflow(workflowJson)` before deploying/importing.
- If using n8n API: also validate by ID with `n8n_validate_workflow({ id })`.

## Practical Tactics

- Fix errors first; treat warnings as risk review.
- When stuck, use `get_node({ mode: 'search_properties' })` to find the controlling field.
- If broken connections show up after edits, prefer fixing connections explicitly (don’t “guess”).

## Related

- Load `n8n-mcp-tools-expert` for tool selection and update patterns.
- Load `n8n-expression-syntax` for expression errors.
