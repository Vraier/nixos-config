{
  config,
  pkgs,
  lib,
  ...
}: {
  # https://tinted-theming.github.io/tinted-gallery/ # for more themese

  stylix.enable = true;
  stylix.enableReleaseChecks = false;
  stylix.base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/gruvbox-light.yaml";
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

  # SPECIALISATIONS (can be used for theme switching)
  #specialisation."solarized-light".configuration = {
  #  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-light.yaml";
  #  stylix.polarity = "light";
  #};

  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.symbols-only
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
  ];
}
