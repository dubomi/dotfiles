#!/usr/bin/env bash
# System initialization. Run this once on a fresh Mac install, and use ./build.sh after.
# The script does four things:
#   1. Installs Determinate Nix if it's not installed already
#   2. Symlinks this repository to ${HOME}/.dotfiles (the home for all the configuration files)
#      Update this file and home.nix to change this (reference mkOutOfStoreSymlink usage in home.nix) 
#   3. Configures user.nix
#   4. Run the initial build. 
set -euo pipefail

if [ "$EUID" -eq 0 ]; then
  echo "Do not run this script with sudo/as root - it needs to run as your normal user"
  echo "(it will call sudo itself for the steps that require elevated privileges)."
  exit 1
fi

HOME="${HOME:-/Users/$(whoami)}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

echo "<<<<< Installing Determinate Nix >>>>>"
if command -v nix >/dev/null 2>&1; then
  echo "Nix already installed, skipping."
else
  echo "Nix not found, installing."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
    | sh -s -- install --no-confirm
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

if ! nix --version >/dev/null 2>&1; then
  echo "Nix was installed but isn't available in this shell yet."
  echo "Restart your terminal (or open a new shell) and re-run this script."
  exit 1
fi

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

echo "<<<<< Run the nix build >>>>>"
# There are two ways to do this:
# 1. darwin-rebuild
#    This is how we'll be doing it after everything is set and done, but since this scripts handles fresh MacOS install,
#    we don't have darwin-rebuild on the machine yet. The following command is pulling down the executable on the fly.
#    
#    NIX_BIN="$(command -v nix)"
#    sudo "$NIX_BIN" run github:nix-darwin/nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake ~/.dotfiles#mac
# 
# 2. nix build
#    darwin-rebuild calls nix build anyway so we'll use this as it's more intuitive here, but from now on (./build.sh)
#    the setup will utilize darwin-rebuild


# nix build
nix build ~/.dotfiles#darwinConfigurations.mac.system
sudo ./result/sw/bin/darwin-rebuild switch --flake ~/.dotfiles#mac

echo "<<<<< Initial setup done. From now on, use ./build.sh to apply changes. >>>>>"
