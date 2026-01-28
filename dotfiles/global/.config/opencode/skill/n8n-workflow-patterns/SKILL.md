---
name: n8n-workflow-patterns
description: Proven n8n workflow architecture patterns (webhook, scheduled, HTTP API, database, AI agent).
license: MIT
compatibility: opencode
metadata:
  category: n8n
  triggers: workflow, workflows, webhook, schedule, cron, http api, database, ai agent, patterns
---

# n8n Workflow Patterns

Use this when you are designing workflow structure, not just individual nodes.

Source: adapted from `czlonkowski/n8n-skills` for OpenCode.

## The 5 Core Patterns

1) Webhook processing
- Webhook -> validate -> transform -> respond/notify

2) HTTP API integration
- Trigger -> HTTP Request -> transform -> action -> error handling

3) Database operations
- Schedule -> query -> transform -> write -> verify

4) AI agent workflows
- Trigger -> AI Agent (model + tools + memory) -> output

5) Scheduled tasks
- Schedule -> fetch -> process -> deliver -> log

## Checklist

- Pick a pattern first.
- List required nodes (use `search_nodes`).
- Define data flow: input -> transform -> output.
- Plan error handling.
- Validate nodes (`validate_node`) and the workflow (`validate_workflow`).

## Common Gotchas

- Webhook payload fields are under `$json.body`.
- Branching nodes (IF/Switch): ensure connections match branches.
- Handle empty datasets (IF before expensive downstream work).

## Related

- Load `n8n-mcp-tools-expert` to drive the build with `search_nodes/get_node/validate_*`.
- Load `n8n-expression-syntax` for mapping data between nodes.
