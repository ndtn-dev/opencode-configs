---
name: bricknet-vps
description: Manage bricknet-edge services via Arcane API or SSH (deploy, restart, pull)
compatibility: opencode
metadata:
  category: infra
  triggers: vps, bricknet-edge, arcane, ssh, docker, deploy, restart
---

# Bricknet VPS Management

Manage bricknet-edge VPS services via Arcane API or SSH.

## Prerequisites

- `ARCANE_API_KEY` env var set (get from Arcane UI: Settings → API Keys)
- SSH access configured in `~/.ssh/config` for `bricknet-edge`

## Workflow

### For docker operations (prefer Arcane API)

```bash
# List projects
arcane-ops.sh list

# Restart a service
arcane-ops.sh restart traefik

# Redeploy (pull + restart)
arcane-ops.sh redeploy n8n

# Staggered restart for opencode/arcane
arcane-ops.sh stagger opencode
arcane-ops.sh stagger arcane
arcane-ops.sh stagger both
```

### For git operations (use SSH)

```bash
# Pull latest changes
ssh bricknet-edge "cd ~/docker && git pull"
```

### Full deploy cycle

1. Commit and push changes to bricknet repo
2. SSH to pull: `ssh bricknet-edge "cd ~/docker && git pull"`
3. Redeploy via Arcane: `arcane-ops.sh redeploy <service>`

## Service locations

All services live in `~/docker/<service>/` on the VPS:
- traefik, authentik, cloudflared, technitium
- netbird, netbird-coordinator
- n8n, ollama, whoami
- arcane, opencode

## Safety rules

- Use `stagger` command for opencode/arcane restarts
- Never restart both arcane and opencode simultaneously
- If Arcane is down, fall back to SSH + stagger-restart.sh on VPS
