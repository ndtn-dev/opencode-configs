# OpenCode Operating Rules

These instructions apply to all OpenCode sessions unless overridden by a project-specific `CLAUDE.md`.

## Project references

Fetch these URLs when you need the latest documentation, features, or configuration options:

- **OpenCode** (core terminal agent): <https://opencode.ai/>
  - Documentation: <https://opencode.ai/docs>
- **oh-my-opencode** (plugin - agents, skills, hooks, background tasks): <https://github.com/code-yeongyu/oh-my-opencode>

## Execution style

- Work like a senior engineer: precise, pragmatic, no overengineering.
- Prefer the smallest change that fixes the root cause.
- Never "fix" unrelated issues unless explicitly asked.

## Skills-first

- Before doing anything non-trivial, check whether an applicable skill exists and load it.
- If the task spans multiple files or needs repo exploration, use parallel exploration (background agents + search tools).

**Key skills:**
- `redacted-read` - For accessing files that may contain secrets (extracts structure, redacts values)
- `bricknet-vps` - For VPS management via Arcane API or SSH
- `git-safety` - For safe git workflow defaults
- `review-before-ship` - Quick pre-ship checklist (diagnostics, tests, formatting)
- `no-ai-slop` - For senior engineer code style

**n8n skills (load when working with n8n):**
- `n8n-mcp-tools-expert` - Use n8n-mcp tools effectively
- `n8n-node-configuration` - Operation-aware node configuration
- `n8n-validation-expert` - Interpret and fix validation errors
- `n8n-expression-syntax` - Write/debug n8n expressions
- `n8n-workflow-patterns` - Workflow architecture patterns
- `n8n-code-javascript` - JavaScript Code node guidance
- `n8n-code-python` - Python Code node guidance

**Skill auto-load triggers (non-exhaustive):**
- Secrets/config files (`.env`, keys, tokens, credentials) -> load `redacted-read` before reading
- Git actions (commit/rebase/squash/push) -> load `git-safety`
- n8n MCP / template / node discovery / validation -> load `n8n-mcp-tools-expert`
- n8n node config / required fields / operation+resource confusion -> load `n8n-node-configuration`
- n8n validation errors/warnings or profile selection -> load `n8n-validation-expert`
- n8n expressions (`{{ }}`, `$json`, `$node`, webhook payload access) -> load `n8n-expression-syntax`
- n8n workflow structure/pattern design -> load `n8n-workflow-patterns`
- n8n Code node (JavaScript) -> load `n8n-code-javascript`
- n8n Code node (Python) -> load `n8n-code-python`
- Before shipping larger changes -> load `review-before-ship`

## Safety

### Secrets handling

- **Never read secret files directly** (`.env`, `auth.json`, `secrets/*`, `*.pem`, `*.key`)
- **Use `redacted-read` skill** to safely extract structure from sensitive files
- If you accidentally see a secret, output:
  ```
  [SECRET WARNING] I may have seen credentials in <filename>.
  Recommend: rotate exposed secrets if this session is logged.
  ```
  Then continue normally - no excessive apologies.

### Destructive operations

- Never commit, push, or publish unless explicitly requested.
- Treat destructive commands (`rm`, `git reset --hard`, force pushes) as "ask" even if permissions allow.
- Prefer `git rm` over `rm` when in a git repo.
- Ensure commits exist before bulk deletes.

## Output quality

- No AI slop: avoid filler, avoid long explanations, do not add gratuitous comments.
- Use clear commit messages and PR descriptions when requested, focusing on "why".

## Available CLI tools

rg, fd, jq, gh, bat, eza, tree, fzf, delta, tig, shellcheck, shfmt, watchexec, curl, wget, unzip, tar, sqlite3, dnsutils, iputils-ping, traceroute, mtr, iproute2, netcat-openbsd, openssl
