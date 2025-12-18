{pkgs, ...}:
pkgs.writeShellScriptBin "os-rebuild" ''
  set -e

  # --- DEPENDENCIES ---
  export PATH=${
    pkgs.lib.makeBinPath [
      pkgs.git
      pkgs.alejandra
      pkgs.nvd
      pkgs.coreutils # Provides readlink
    ]
  }:$PATH

  # --- CONFIGURATION ---
  FLAKE_DIR="$HOME/nixos-config"
  cd "$FLAKE_DIR"

  # --- 1. FORMATTING ---
  echo "Formatting Nix files..."
  alejandra . >/dev/null

  # --- 2. GIT CHECK ---
  if [ -z "$(git status --porcelain)" ]; then
    echo "No changes to build!"
    exit 0
  fi

  git add .

  # --- 3. REBUILD ---
  echo "Rebuilding NixOS..."

  # SNAPSHOT: Get the path to the system configuration BEFORE we switch
  # 'readlink -f' resolves the symlink to the actual /nix/store/... path
  OLD_SYSTEM=$(readlink -f /nix/var/nix/profiles/system)

  # SWITCH
  sudo nixos-rebuild switch --flake .

  # SNAPSHOT: Get the path AFTER the switch
  NEW_SYSTEM=$(readlink -f /nix/var/nix/profiles/system)

  # --- 4. SHOW DIFF ---
  echo "Calculating changes..."

  # Check if the system actually changed
  if [ "$OLD_SYSTEM" != "$NEW_SYSTEM" ]; then
    nvd diff "$OLD_SYSTEM" "$NEW_SYSTEM"
  else
    echo "No package version changes detected."
  fi

  # --- 5. COMMIT ---
  echo ""
  echo "Enter commit message (press Enter for default):"
  read -p "> " msg

  if [ -z "$msg" ]; then
    msg="System rebuild: $(date +'%Y-%m-%d %H:%M')"
  fi

  git commit -m "$msg"

  echo "Done! System updated and changes committed."
  sleep 2
''
