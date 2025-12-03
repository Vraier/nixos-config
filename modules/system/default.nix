{ pkgs, ... }:

{
  imports = [
    ./hyprland/hyprland.nix
    ./stylix/stylix.nix
    ./basic/basic.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    tree
    nix-search-tv
  ];
}