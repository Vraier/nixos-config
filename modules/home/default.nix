{ pkgs, ... }:

{
  imports = [
    ./firefox/firefox.nix
    ./hyprland/hyprland.nix
    ./cli/cli.nix
    ./ssh/ssh.nix
    ./git/git.nix
    ./vscode/vscode.nix
  ];

  programs.home-manager.enable = true;
  stylix.enableReleaseChecks = false;

  home.packages = with pkgs; [
    adwaita-icon-theme
    hicolor-icon-theme 
  ];
}