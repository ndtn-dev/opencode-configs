#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_DIR="$ROOT_DIR/dotfiles/global/.config/opencode"

if ! command -v opencode >/dev/null 2>&1; then
  echo "opencode is not installed" >&2
  exit 1
fi

echo "Using OPENCODE_CONFIG_DIR=$CONFIG_DIR"

echo
opencode --version

echo
echo "== Skills =="
OPENCODE_CONFIG_DIR="$CONFIG_DIR" opencode debug skill

echo
echo "== Agents =="
OPENCODE_CONFIG_DIR="$CONFIG_DIR" opencode debug agent oc-review

echo
echo "== Config (effective) =="
OPENCODE_CONFIG_DIR="$CONFIG_DIR" opencode debug config
