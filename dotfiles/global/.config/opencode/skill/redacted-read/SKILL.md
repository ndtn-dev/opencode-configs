---
name: redacted-read
description: Safely explore files that may contain secrets by extracting structure while redacting sensitive values. Agentic - uses judgment and CLI tools dynamically.
license: MIT
compatibility: opencode
metadata:
  category: security
  triggers: secrets, .env, credentials, ssh config, auth, tokens, sensitive files
---

# Redacted Read

## Primary Objective

**Explore files that may contain secrets while protecting sensitive values.**

You need to understand a file's structure, available options, or configuration schema - but the file may contain credentials, tokens, API keys, or other secrets. Your goal is to extract the useful structural information while ensuring secrets are never exposed in your output.

## When to Proactively Use This Skill

Load this skill BEFORE reading files that match these patterns:
- `.env`, `.env.*` (except `.env.example`)
- `auth.json`, `credentials.*`, `secrets.*`
- `~/.ssh/config`, `~/.ssh/id_*`
- `*.pem`, `*.key`
- Any file in a `secrets/` directory
- Files the coordinator flags as `[sensitive]`

## Core Principles

1. **Structure over values** - Show what keys/variables exist, not their secret values
2. **Preserve utility** - Extract actionable info (hostnames to SSH into, env vars to set, config keys to modify)
3. **Redact dynamically** - Use judgment on what constitutes a secret based on context
4. **Fail safe** - When uncertain, redact more rather than less
5. **Progressive disclosure** - Show high-level structure first, offer to drill into sections
6. **Be transparent** - If you cannot safely extract what is needed, say so and offer options

## Escalation Ladder

Work through these steps in order. Only escalate when the current step is insufficient:

### Step 1: Structure-only extraction (safest)

Extract keys, field names, or section headers without touching values:

```bash
# .env - show variable names only
grep -oE '^[A-Za-z_][A-Za-z0-9_]*=' .env | sed 's/=$//'

# JSON - show all key paths
jq -r 'paths(scalars) | join(".")' file.json

# YAML - show top-level keys
grep -E '^[a-zA-Z_-]+:' file.yaml | cut -d: -f1

# SSH config - show Host entries only
grep -E '^Host ' ~/.ssh/config
```

### Step 2: Pattern-based redaction

When you need to show structure WITH placeholder values:

```bash
# SSH config - show hosts with redacted details
awk '
  /^Host / {print}
  /^[[:space:]]+(HostName|User|Port|IdentityFile|ProxyJump)/ {
    print $1, "<REDACTED>"
  }
  /^[[:space:]]+[A-Za-z]/ && !/HostName|User|Port|IdentityFile|ProxyJump/ {print}
' ~/.ssh/config

# .env - preserve comments, redact values
awk '/^#/ {print; next} /=/ {split($0,a,"="); print a[1] "=<REDACTED>"}' .env
```

### Step 3: Format detection (line-by-line, max 3 sequential)

When you need to identify file format before choosing extraction strategy:

```bash
# Line 1 - usually reveals format
head -1 file

# Line 2 - if line 1 was comment/empty
head -2 file | tail -1

# Line 3 - last sequential read
head -3 file | tail -1

# STOP after 3. If still seeing comments, PIVOT:
grep -v '^#\|^$' file | head -1
```

**Format indicators:**
- `{` = JSON
- `---` = YAML
- `# comment` = env, shell, config
- `Host xyz` = SSH config
- `[section]` = INI
- `-----BEGIN` = PEM key

**After 3 comment lines, pivot strategy** - don't read lines 4-5 sequentially. Use grep to skip comments instead.

### Step 4: Partial peek (user-approved risk)

When you have identified values but need to determine their TYPE (API key vs random string):

**Only use when:**
- Earlier steps were insufficient
- You need to identify what KIND of secret it is
- You accept showing first ~8 chars

**Implementation:**
```bash
# Show prefix, hide tail (always mask last 6+ chars)
value="sk-ant-api03-actualSecretHere"
len=${#value}
if [ $len -le 6 ]; then
  echo "[redacted]"
else
  show=$((len - 6))
  [ $show -gt 8 ] && show=8
  echo "${value:0:$show}~~~"
fi
```

**Output format:**
```
ANTHROPIC_KEY=sk-ant-a~~~
GITHUB_TOKEN=ghp_xxxx~~~
SHORT_SECRET=[redacted]
```

**After partial peek, always report:**
```
[PARTIAL PEEK] Peeked at N values to identify types.
Show peeked lines? [y/n]
```

If user says yes, show the exact lines that were peeked.

### Step 5: Ask for guidance

When partial peek is too risky or you are stuck:

```
I have exhausted safe extraction methods for <filename>.

Options:
1. [RISKY] I can partial-peek (show first ~8 chars, hide rest)
   You would need to approve this - some prefix exposure

2. [MANUAL] Run these commands yourself and tell me what you see:
   <provide specific commands tailored to the file>

   Example commands:
   jq 'keys' auth.json
   grep -oE '^[A-Z_]+=' .env
   awk '/^Host /{print $2}' ~/.ssh/config

3. [DIFFERENT APPROACH] Tell me what you are trying to accomplish
   and I will find another way that does not require this file
```

## Pattern-Based Secret Detection

Always redact values matching these patterns:

**API key prefixes:**
- `sk-`, `pk-` (Stripe, Anthropic)
- `ghp_`, `gho_`, `ghs_` (GitHub)
- `xox[baprs]-` (Slack)
- `AKIA` (AWS)
- `Bearer `, `Basic ` (auth headers)

**Structural patterns:**
- Base64 strings longer than 40 chars
- URLs with embedded credentials (`https://user:pass@`)
- Hex strings longer than 32 chars

**Key names to always redact values for:**
password, secret, token, key, credential, auth, api_key, apikey, private, access_token, refresh_token

## Output Format

When presenting redacted content:
- `<REDACTED>` - simple redaction
- `<REDACTED:type>` - with hint (`:key`, `:ip`, `:path`, `:url`, `:base64`)
- `value~~~` - partial peek format (prefix shown, tail hidden)
- Preserve structure, indentation, and comments
- Show enough context for user to understand what is available

## Reporting Back to Coordinator

When used as a subagent, summarize findings clearly:

```
Scanned: ~/.config/app/credentials.json
Structure: 3 top-level keys (api, database, oauth)
Secrets found: 5 values redacted (2 API keys, 1 password, 2 tokens)
Safe to share: key names, nesting structure, non-secret config values

Actionable: The "api.endpoint" field is "https://api.example.com" (not a secret)
```

## Cross-References

After extracting information, suggest relevant next steps:
- Found SSH hosts? → "Use `/ssh <hostname>` to connect"
- Found env vars? → "These vars need to be set: VAR1, VAR2, VAR3"
- Found API structure? → "The auth.json expects: client_id, client_secret, refresh_token"

## Secret Warning Protocol

If you accidentally read a file and see what appears to be a secret:

```
[SECRET WARNING] I may have seen credentials in <filename>.
Recommend: rotate exposed secrets if this session is logged.
```

Then continue normally. No excessive apologies - flag it clearly and move on.

## Example Scenarios

**User asks:** "What SSH hosts do I have?"
```
1. grep '^Host ' ~/.ssh/config → get host names
2. Report: "You have 5 hosts: prod, staging, dev, bastion, backup"
3. Suggest: "Use /ssh <hostname> to connect to any of these"
```

**User asks:** "What env vars does this app need?"
```
1. grep -oE '^[A-Z_]+=' .env | sort -u → get var names
2. Group by prefix if patterns emerge (DB_, API_, AUTH_)
3. Report: "App needs 12 env vars: 3 database, 4 API, 2 auth, 3 misc"
```

**User asks:** "What is the structure of auth.json?"
```
1. jq 'paths(scalars) | join(".")' auth.json → get all paths
2. Identify which paths likely contain secrets
3. Report structure with [REDACTED] placeholders for secret values
```
