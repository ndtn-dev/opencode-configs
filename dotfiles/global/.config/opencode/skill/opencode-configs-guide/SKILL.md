---
name: opencode-configs-guide
description: Guide for managing opencode-configs - the single source of truth for OpenCode configuration across all environments
compatibility: opencode
metadata:
  category: meta
  triggers: opencode setup, config management, stow, symlink, dotfiles
---

# OpenCode Configs Guide

## Purpose

`opencode-configs` is the **single source of truth** for all OpenCode configuration. It can be cloned and deployed to any environment (VPS containers, local dev machines) using GNU Stow.

## Repository Structure

```
opencode-configs/
├── dotfiles/
│   └── global/
│       └── .config/
│           └── opencode/
│               ├── AGENTS.md          # AI operating rules
│               ├── CLAUDE.md          # Mirror of AGENTS.md
│               ├── opencode.json      # Main config + permissions
│               ├── oh-my-opencode.json # Agent model assignments
│               ├── agent/             # Custom agent definitions
│               │   └── oc-review.md
│               └── skill/             # Available skills
│                   ├── redacted-read/
│                   ├── bricknet-vps/
│                   ├── git-safety/
│                   ├── no-ai-slop/
│                   └── review-before-ship/
└── scripts/
    ├── deploy-global.sh               # Interactive stow deployment
    └── deploy-global-noninteractive.sh
```

## Deployment

### On any machine (local or remote)

```bash
# Clone the repo
git clone <repo-url> ~/Projects/opencode-configs
cd ~/Projects/opencode-configs

# Deploy with GNU Stow
./scripts/deploy-global.sh

# Or non-interactive
./scripts/deploy-global-noninteractive.sh
```

This creates symlinks:
```
~/.config/opencode/ -> ~/Projects/opencode-configs/dotfiles/global/.config/opencode/
```

### In Docker containers

The container's entrypoint should:
1. Clone opencode-configs to /home/opencode/Projects/opencode-configs
2. Run stow to create symlinks
3. OpenCode then uses the symlinked config

## Making Changes

### Adding a new skill

```bash
mkdir -p dotfiles/global/.config/opencode/skill/my-skill/
cat > dotfiles/global/.config/opencode/skill/my-skill/SKILL.md << 'EOF'
---
name: my-skill
description: What this skill does
compatibility: opencode
---

# My Skill

Content here...
EOF
```

### Updating permissions

Edit `dotfiles/global/.config/opencode/opencode.json` and modify the `permission` section.

### After changes

```bash
cd ~/Projects/opencode-configs
git add -A
git commit -m "feat: add my-skill"
git push
```

Other environments pull and re-stow to get updates.

## Relationship with bricknet

- `bricknet` repo contains Docker service configs (Dockerfile, compose.yaml, .env)
- `opencode-configs` contains OpenCode-specific configs (skills, permissions, agent rules)
- The bricknet opencode container clones opencode-configs and stows it
- Container-specific files stay in bricknet; OpenCode configs come from opencode-configs

## Troubleshooting

### Configs not loading

Check symlinks exist:
```bash
ls -la ~/.config/opencode/
```

Re-run stow:
```bash
cd ~/Projects/opencode-configs && stow -R -t $HOME dotfiles/global
```

### Conflicts

If stow reports conflicts, existing files may need to be removed first:
```bash
rm ~/.config/opencode/opencode.json  # if it's a real file, not a symlink
stow -R -t $HOME dotfiles/global
```
