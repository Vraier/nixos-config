#!/bin/sh
set -e

FLAKE_DIR="$HOME/nixos-config"
cd "$FLAKE_DIR"

echo "Formatting Nix files..."
alejandra . >/dev/null

if [ -z "$(git status --porcelain)" ]; then
  echo "No changes to build!"
  exit 0
fi

git add .

echo "Rebuilding NixOS..."

OLD_SYSTEM=$(readlink -f /nix/var/nix/profiles/system)

sudo nixos-rebuild switch --flake .

NEW_SYSTEM=$(readlink -f /nix/var/nix/profiles/system)

echo "Calculating changes..."

if [ "$OLD_SYSTEM" != "$NEW_SYSTEM" ]; then
  nvd diff "$OLD_SYSTEM" "$NEW_SYSTEM"
else
  echo "No package version changes detected."
fi
msg="System rebuild: $(date +'%Y-%m-%d %H:%M')"

git commit -m "$msg"

echo "Done! System updated and changes committed."
