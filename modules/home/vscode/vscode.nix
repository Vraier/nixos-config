{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      ms-python.python
      ms-python.vscode-pylance
      ms-vscode.cpptools
      bbenoist.nix
      tamasfe.even-better-toml
      github.copilot-chat
      github.copilot
      github.vscode-pull-request-github
    ];
  };
}
