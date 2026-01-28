---
name: n8n-code-python
description: Write correct Python in n8n Code nodes; understand limitations (stdlib-only), data access, and return shape.
license: MIT
compatibility: opencode
metadata:
  category: n8n
  triggers: code node, python, _input, _json, _node
---

# n8n Code Node: Python

Use this when writing Python in n8n’s Code node.

Source: adapted from `czlonkowski/n8n-skills` for OpenCode.

## Recommendation

Prefer JavaScript unless you specifically need Python.

## Non-Negotiables

- Return a list of dicts: `[{"json": {...}}]`.
- Webhook payload fields are under `_json["body"]`.
- No third-party libraries (stdlib-only).

## Template

```python
items = _input.all()

out = []
for item in items:
    out.append({
        "json": {
            **item["json"],
            "processed": True,
        }
    })

return out
```

## Common Failures

- `import requests` / pandas / numpy (not available)
- KeyError from direct indexing (prefer `.get()`)
- Returning a dict instead of a list
