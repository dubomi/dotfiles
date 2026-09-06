#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 <flake-output>  (e.g. nixos or nixos-i)" >&2
  exit 1
fi

HOST="$1"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles
exec sudo nixos-rebuild switch --flake "$HOME/.dotfiles/nixos#$HOST"
