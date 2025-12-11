{ pkgs, ... }:

{
  imports = [
    ./wayland.nix

    #./hyprland.nix
    ./niri/niri.nix

    ./waybar.nix
    ./hyprlock.nix
    ./fuzzel.nix
  ];
}
