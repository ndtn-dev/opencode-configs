---
name: n8n-code-javascript
description: Write correct JavaScript in n8n Code nodes (data access, return shape, common pitfalls, webhook body).
license: MIT
compatibility: opencode
metadata:
  category: n8n
  triggers: code node, javascript, $input, $json, $node, $helpers, httpRequest, DateTime
---

# n8n Code Node: JavaScript

Use this when writing JavaScript in n8n’s Code node.

Source: adapted from `czlonkowski/n8n-skills` for OpenCode.

## Non-Negotiables

- Return an array of items, each shaped like `{ json: {...} }`.
- Prefer "Run once for all items" mode unless you truly need per-item execution.
- Webhook payload fields are under `$json.body`.

## Template

```javascript
const items = $input.all();

return items.map((item) => ({
  json: {
    ...item.json,
    processedAt: new Date().toISOString(),
  },
}));
```

## Data Access

- `$input.all()` (most common)
- `$input.first()` (single item workflows)
- `$node["Some Node"].json` (reference other nodes)

## Common Failures

- Returning an object instead of an array
- Returning `[{...}]` without `json` wrapper
- Using `{{ }}` expression syntax inside Code node strings
