#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOTFILES_DIR="$ROOT_DIR/dotfiles"

if ! command -v stow >/dev/null 2>&1; then
  echo "stow is required (brew/apt install stow)" >&2
  exit 1
fi

cd "$DOTFILES_DIR"

stow -R -t "$HOME" global
