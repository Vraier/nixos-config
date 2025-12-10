{ pkgs, ... }:

{
  imports = [
    ./hyprlock.nix
    #./hyprland.nix
    ./niri.nix
    ./waybar.nix
    ./wayland.nix
  ];
}
