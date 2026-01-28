---
name: n8n-expression-syntax
description: Write and debug n8n expressions ({{}}), including correct webhook body access and node references.
license: MIT
compatibility: opencode
metadata:
  category: n8n
  triggers: n8n, expression, expressions, {{ }}, $json, $node, webhook, $env, $now
---

# n8n Expression Syntax

Use this when you are writing or debugging n8n expressions.

Source: adapted from `czlonkowski/n8n-skills` for OpenCode.

## Expression Format

In most n8n fields, dynamic content uses double curly braces:

```text
{{ expression }}
```

Examples:

```text
{{$json.email}}
{{$json.body.name}}
{{$node["HTTP Request"].json.data}}
```

## Core Variables

- `$json`: current node output

```text
{{$json.fieldName}}
{{$json['field with spaces']}}
{{$json.items[0].name}}
```

- `$node`: reference prior node output (node name must match exactly; case-sensitive)

```text
{{$node["Webhook"].json.body.email}}
{{$node["HTTP Request"].json.data.items[0].name}}
```

- `$now`: current timestamp (Luxon DateTime)

```text
{{$now.toFormat('yyyy-MM-dd')}}
{{$now.plus({days: 7}).toISO()}}
```

- `$env`: environment variables

```text
{{$env.MY_VAR}}
```

## Critical: Webhook Data Is Under `.body`

Most common mistake: webhook payload fields are not at the root.

```text
WRONG: {{$json.email}}
RIGHT: {{$json.body.email}}
```

## When NOT to Use {{ }}

- Code node: use JavaScript/Python accessors, not expression syntax.

```javascript
// In Code node (JS)
const email = $json.body?.email;
```

```python
# In Code node (Python)
email = _json.get('body', {}).get('email')
```

## Quick Validation Checklist

- Braces: `{{ ... }}` present
- Node references: `$node["Exact Name"]` (quotes required)
- Webhook payload: `$json.body.*`
- Field names with spaces: bracket notation `['field name']`

## Debugging

- If expression renders as literal text: missing `{{ }}` or field isn't expression-enabled.
- If you see "Cannot read property ... of undefined": path is wrong; add null checks or verify structure.

## Related

- Load `n8n-mcp-tools-expert` for tool-driven validation (e.g., `validate_node`, `validate_workflow`).
