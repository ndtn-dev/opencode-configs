#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOTFILES_DIR="$ROOT_DIR/dotfiles"

if ! command -v stow >/dev/null 2>&1; then
  echo "stow is required (brew/apt install stow)" >&2
  exit 1
fi

cd "$DOTFILES_DIR"

echo "[dry-run] stow -n -R -t $HOME global"
stow -n -R -t "$HOME" global

echo
read -r -p "Apply these symlinks? Type 'yes' to continue: " confirm
if [[ "$confirm" != "yes" ]]; then
  echo "Aborted."
  exit 2
fi

echo "[apply] stow -R -t $HOME global"
stow -R -t "$HOME" global

echo "Done."
