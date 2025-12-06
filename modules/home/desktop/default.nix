{ pkgs, ... }:

{
  imports = [
    ./hyprlock.nix
    ./hyprland.nix
    ./waybar.nix
    ./wayland.nix
  ];
}
