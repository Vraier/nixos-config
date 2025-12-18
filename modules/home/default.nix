{
  pkgs,
  inputs,
  ...
}: let
  pkgsStable = import inputs.nixpkgs-stable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in {
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

  home.packages = [
    pkgs.pavucontrol
    #pkgs.overskride # bluetooth manager, maybe will work some day :(
    pkgs.blueman
    pkgs.networkmanagerapplet
    pkgs.signal-desktop
  ];
}
