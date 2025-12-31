{
  config,
  pkgs,
  lib,
  ...
}: let
  defaultTheme = "gruvbox-dark-hard";

  switch-theme = pkgs.writeShellScriptBin "switch-theme" ''
    THEME="$1"
    FLAKE_PATH="/home/jp/nixos-config#jp-pc"
    DEFAULT="${defaultTheme}"

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
    # Change to 'switch' if you want the theme to persist after reboot.
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
  '';
in {
  environment.systemPackages = [switch-theme];

  stylix.enable = true;
  stylix.enableReleaseChecks = false;
  #stylix.base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  #stylix.polarity = lib.mkDefault "dark";

  stylix.base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/rose-pine-dawn.yaml";
  stylix.polarity = lib.mkDefault "light";

  stylix.image = ../../../assets/wallpapers/gruvbox/Bixby_Creek_Bridge_over_a_cliff.jpg;

  stylix.iconTheme = {
    enable = true;
    package = pkgs.papirus-icon-theme;
    dark = "Papirus-Dark";
    light = "Papirus-Light";
  };

  stylix.cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
    };
    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
    };
    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };
    emoji = {
      package = pkgs.nerd-fonts.symbols-only;
      name = "Symbols Nerd Font Mono";
    };
  };

  stylix.fonts.sizes = {
    applications = 12;
    terminal = 12;
    desktop = 12;
    popups = 12;
  };

  stylix.opacity = {
    applications = 1.0;
    terminal = 1.0;
    desktop = 1.0;
    popups = 1.0;
  };

  # SPECIALISATIONS
  #specialisation."nord".configuration.stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
  #specialisation."solarized-dark".configuration.stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-dark.yaml";

  specialisation."dracula".configuration.stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
  specialisation."solarized-light".configuration = {
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
    stylix.polarity = "light";
  };

  #specialisation."tokyo-night".configuration.stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";

  #specialisation."onedark".configuration.stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";

  #specialisation."everforest".configuration.stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/everforest.yaml";

  #specialisation."rose-pine".configuration.stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
  #specialisation."rose-pine-moon".configuration.stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
  #specialisation."rose-pine-dawn".configuration = {
  #  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-dawn.yaml";
  #  stylix.polarity = "light";
  #};

  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.symbols-only
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
  ];
}
