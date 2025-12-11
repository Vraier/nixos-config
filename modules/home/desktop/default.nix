{ pkgs, ... }:

{
  imports = [
    ./wayland.nix

    #./hyprland/hyprland.nix
    ./niri/niri.nix

    ./waybar.nix
    ./hyprlock.nix
    ./fuzzel.nix
  ];
}
