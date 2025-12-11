{ pkgs, config, lib, ... }: {
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        placeholder = "Run...";
        terminal = "${pkgs.alacritty}/bin/alacritty -e";

        # Layout
        font = lib.mkForce "${config.stylix.fonts.monospace.name}:size=20";
        width = 45; # Width in characters
        lines = 15; # Number of items to show
        horizontal-pad = 20;
        vertical-pad = 10;
        inner-pad = 5;
      };

      border = {
        width = 3;
        radius = 30;
        selection-radius = 15;
      };
    };
  };
}
