#!/usr/bin/env bash
# System initialization for a fresh NixOS install. Run this once per host, and
# use ./build.sh <host> after.
# Unlike macOS, NixOS already ships with Nix -- there's nothing to install here.
# The script does three things:
#   1. Symlinks this repository to ${HOME}/.dotfiles (the home for all the configuration files)
#      Update this file and home.nix to change this (reference mkOutOfStoreSymlink usage in home.nix)
#   2. Configures user.nix
#   3. Runs the initial switch
set -euo pipefail

if [ "$EUID" -eq 0 ]; then
  echo "Do not run this script with sudo/as root - it needs to run as your normal user"
  echo "(it will call sudo itself for the steps that require elevated privileges)."
  exit 1
fi

if [ $# -ne 1 ]; then
  echo "Usage: $0 <flake-output>  (e.g. nixos or nixos-i)" >&2
  exit 1
fi

HOST="$1"
HOME="${HOME:-/home/$(whoami)}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

echo "<<<<< Symlink this repository to ${HOME}/.dotfiles >>>>>"
# home.nix resolves its mkOutOfStoreSymlink paths through ~/.dotfiles, so this
# has to exist before the first switch or the build will fail to find them.
ln -sfn "$DIR" ~/.dotfiles

echo "<<<<< Configure user.nix >>>>>"
# on some systems, sudo resets $USER to root, so using whoami here before the sudo call
# to grab the real user name.
REAL_USER="$(whoami)"
USER_NIX_FILE="$DIR/user.nix"

if [ ! -f "$USER_NIX_FILE" ]; then
  echo "\"$REAL_USER\"" > "$USER_NIX_FILE"
  # Need to track the file with git, otherwise nix will fail.
  # The file is tracked with -N (--intent-to-add) and it's ignored in .gitignore to
  # prevent accidentally committing it.
  git -C "$DIR" add -N -f "$USER_NIX_FILE" 2>/dev/null || true
  echo "    Created user.nix configured for \"$REAL_USER\"."
else
  CURRENT_USER="$(tr -d ' "' < "$USER_NIX_FILE")"
  if [ "$CURRENT_USER" != "$REAL_USER" ]; then
    echo "    user.nix is configured for user \"$CURRENT_USER\", but you are \"$REAL_USER\"."
    read -r -p "    Update user.nix to \"$REAL_USER\"? [y/N] " REPLY
    if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ]; then
      echo "\"$REAL_USER\"" > "$USER_NIX_FILE"
      echo "    Updated user.nix."
    else
      echo "    Skipped. Edit user.nix yourself before continuing."
      exit 1
    fi
  else
    echo "    user.nix already matches \"$REAL_USER\", nothing to do."
  fi
fi

echo "<<<<< Run the initial switch >>>>>"
# Stock NixOS doesn't enable flakes by default. nixos/configuration.nix turns
# them on permanently, but that setting isn't active until AFTER this first
# switch succeeds -- so bootstrap it here with a one-off CLI flag instead.
sudo nixos-rebuild switch \
  --extra-experimental-features "nix-command flakes" \
  --flake "$HOME/.dotfiles/nixos#$HOST"

echo "<<<<< Initial setup done. From now on, use ./build.sh $HOST to apply changes. >>>>>"
