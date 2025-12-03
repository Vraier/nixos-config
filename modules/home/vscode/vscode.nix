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
      yzhang.markdown-all-in-one
    ];
  };
}