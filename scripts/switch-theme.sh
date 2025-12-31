THEME="$1"
FLAKE_PATH="/home/jp/nixos-config"

list_themes() {
  echo "$DEFAULT"
  # Check persistent profile (created by 'switch')
  if [ -d /nix/var/nix/profiles/system/specialisation ]; then
    ls -1 /nix/var/nix/profiles/system/specialisation
  # Check current ephemeral system (created by 'test')
  elif [ -d /run/current-system/specialisation ]; then
    ls -1 /run/current-system/specialisation
  fi
}

if [ "$THEME" = "--list" ] || [ "$THEME" = "-l" ]; then
  list_themes | sort -u
  exit 0
fi

if [ -z "$THEME" ]; then
  echo "Usage: switch-theme <theme_name> | --list"
  echo "Available themes:"
  list_themes | sort -u
  exit 1
fi

# Validate theme existence
if ! list_themes | sort -u | grep -Fqx "$THEME"; then
  echo "Error: Theme '$THEME' is not valid."
  echo "Available themes:"
  list_themes | sort -u
  exit 1
fi

echo "Target Theme: $THEME"
# Using 'test' allows fast switching without modifying boot entries.
if [ "$THEME" = "$DEFAULT" ]; then
  echo "Applying Base Configuration ($DEFAULT)..."
  sudo nixos-rebuild test --flake "$FLAKE_PATH"
else
  echo "Applying Specialization: $THEME..."
  sudo nixos-rebuild test --flake "$FLAKE_PATH" --specialisation "$THEME"
fi

echo "Theme switch complete."
echo "Window will close in 3 seconds..."
sleep 3