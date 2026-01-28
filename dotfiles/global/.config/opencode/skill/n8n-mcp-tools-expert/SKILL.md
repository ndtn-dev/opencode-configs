---
name: n8n-mcp-tools-expert
description: Use n8n-mcp tools effectively (search_nodes/get_node/validate_node/templates and n8n_* management APIs).
license: MIT
compatibility: opencode
metadata:
  category: n8n
  triggers: n8n-mcp, mcp, search_nodes, get_node, validate_node, validate_workflow, templates, n8n_create_workflow
---

# n8n MCP Tools Expert

Use this when you are building/validating n8n workflows with the `n8n-mcp` MCP server.

Source: adapted from `czlonkowski/n8n-skills` for OpenCode.

## Tool Set (current n8n-mcp)

Core docs/data tools:
- `tools_documentation`
- `search_nodes`
- `get_node`
- `validate_node`
- `search_templates`
- `get_template`
- `validate_workflow`

n8n management tools (require `N8N_API_URL` + `N8N_API_KEY`):
- `n8n_health_check`
- `n8n_list_workflows`, `n8n_get_workflow`
- `n8n_create_workflow`
- `n8n_update_partial_workflow`, `n8n_update_full_workflow`
- `n8n_validate_workflow`, `n8n_autofix_workflow`
- `n8n_test_workflow`, `n8n_executions`
- `n8n_deploy_template`, `n8n_workflow_versions`, `n8n_delete_workflow`

## Default Workflow (fast + reliable)

1) Discover nodes

```js
search_nodes({ query: 'slack' })
get_node({ nodeType: 'nodes-base.slack', detail: 'standard', includeExamples: true })
```

2) Validate node configs iteratively

```js
validate_node({ nodeType: 'nodes-base.slack', config, mode: 'minimal' })
validate_node({ nodeType: 'nodes-base.slack', config, mode: 'full', profile: 'runtime' })
```

3) Prefer templates first (often fastest)

```js
search_templates({ query: 'webhook slack' })
get_template({ templateId, mode: 'structure' })
validate_workflow(workflowJson)
```

4) If API is configured: manage workflows via `n8n_*`

```js
n8n_health_check({ mode: 'status' })
n8n_list_workflows({ limit: 10 })
```

## Critical: nodeType Formats

Two strings show up:
- short: `nodes-base.httpRequest` (used by `get_node`, `validate_node`)
- workflow: `n8n-nodes-base.httpRequest` (used inside workflow JSON)

When you `search_nodes`, capture both `nodeType` and `workflowNodeType` and use the right one.

## Guidance

- Prefer `detail: 'standard'` by default.
- Use `mode: 'search_properties'` for targeted digging:

```js
get_node({ nodeType: 'nodes-base.httpRequest', mode: 'search_properties', propertyQuery: 'auth' })
```

- Always validate after changes; expect 2-3 validate/fix loops.
- Avoid relying on n8n defaults; set critical fields explicitly.
