---
name: n8n-node-configuration
description: Configure n8n nodes correctly with operation-aware required fields and property dependencies.
license: MIT
compatibility: opencode
metadata:
  category: n8n
  triggers: configure, configuration, properties, dependencies, resource, operation, displayOptions
---

# n8n Node Configuration

Use this when you are configuring a node and keep hitting missing-field / conditional-field issues.

Source: adapted from `czlonkowski/n8n-skills` for OpenCode.

## Rules of Thumb

- Configuration is operation-aware: `resource` + `operation` changes required fields.
- Properties can be conditional (visibility depends on other fields).
- Start minimal, then expand based on validation.

## Recommended Workflow

1) `get_node({ detail: 'standard' })` first (default)
2) fill required fields for the chosen operation
3) `validate_node(..., profile: 'runtime')`
4) if stuck, `get_node({ mode: 'search_properties', propertyQuery: '...' })`

Example targeted search:

```js
get_node({ nodeType: 'nodes-base.httpRequest', mode: 'search_properties', propertyQuery: 'authentication' })
```

## Common Patterns

- Resource/operation nodes (Slack, Sheets):
  - set `resource`, set `operation`, then set operation-specific fields.
- HTTP Request:
  - POST usually needs body toggles; validation will guide you.
- IF/Switch:
  - operator shape differs for unary/binary operators; rely on validation.
