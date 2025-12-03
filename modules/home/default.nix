{ ... }:

{
  imports = [
    ./firefox/firefox.nix
    ./hyprland/hyprland.nix
    ./git/git.nix
    ./vscode/vscode.nix
  ];

  programs.tealdeer = {
    enable = true;
    enableAutoUpdates = true;
  };

  programs.home-manager.enable = true;

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
      };
    };
  };
}