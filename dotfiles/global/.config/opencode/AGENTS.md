# OpenCode Operating Rules

These instructions apply to all OpenCode sessions unless overridden by a closer `AGENTS.md`.

## Execution style

- Work like a senior engineer: precise, pragmatic, no overengineering.
- Prefer the smallest change that fixes the root cause.
- Never "fix" unrelated issues unless explicitly asked.

## Skills-first

- Before doing anything non-trivial, check whether an applicable skill exists and load it with the `skill` tool.
- If the task spans multiple files or needs repo exploration, use parallel exploration (background agents + search tools).

## Safety

- Never commit, push, or publish unless explicitly requested.
- Treat destructive shell commands (`rm`, `git reset --hard`, force pushes) as "ask" even if permissions allow.
- Do not read secret files (e.g., `.env`) unless explicitly requested.

## Output quality

- No AI slop: avoid filler, avoid long explanations, do not add gratuitous comments.
- Use clear commit messages and PR descriptions when requested, focusing on "why".

## Available CLI tools

- rg (ripgrep), fd, jq, gh
- bat, eza, tree, fzf
- delta, tig
- shellcheck, shfmt, watchexec
- curl, wget, unzip, tar, sqlite3
- dnsutils (dig, nslookup), iputils-ping
- traceroute, mtr
- iproute2 (ip), netcat-openbsd (nc), openssl
