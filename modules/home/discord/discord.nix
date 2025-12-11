{ config, pkgs, ... }:

{
  programs.vesktop.enable = true;
  # programs.discord.enable = true; # will i ever use you?

  home.packages = with pkgs; [
    xdg-desktop-portal-hyprland
    pkgs.xdg-desktop-portal-gnome
  ];
}
