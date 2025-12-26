{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    # Search here: https://search.nixos.org/packages
    profiles.default.extensions = with pkgs.vscode-extensions; [
      ms-python.python
      ms-python.vscode-pylance
      ms-vscode.cpptools
      jnoortheen.nix-ide
      tamasfe.even-better-toml
      github.copilot-chat
      github.copilot
      github.vscode-pull-request-github
    ];
  };
}
