{ pkgs, ... }:

{
  imports = [
    ./desktop/wayland.nix
    ./stylix/stylix.nix
    ./basic/basic.nix
    ./steam/steam.nix
    ./nixos/nixos.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    tree
    nix-search-tv
    nixpkgs-fmt
    parted
    btrfs-progs
  ];
}
