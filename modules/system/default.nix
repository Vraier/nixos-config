{ pkgs, ... }:

{
  imports = [
    ./hyprland/hyprland.nix
  ];

  stylix.enable = true;
  stylix.enableReleaseChecks = false;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

}