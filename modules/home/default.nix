{ pkgs, ... }:

{
  imports = [
    ./firefox/firefox.nix
    ./desktop/default.nix
    ./discord/discord.nix
    ./cli/cli.nix
    ./ssh/ssh.nix
    ./git/git.nix
    ./vscode/vscode.nix
  ];

  programs.home-manager.enable = true;
  stylix.enableReleaseChecks = false;

  home.packages = with pkgs; [
    pavucontrol
  ];
}
