{ config, pkgs, ... }:

{
  programs.discord = {
    enable = true;
    #enableOpenBrowser = true;
  };

  home.packages = with pkgs; [
    xdg-desktop-portal-hyprland
    # armcord # An unofficial client built on Electron/Nativefier
  ];
}
