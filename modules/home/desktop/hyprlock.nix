{ config, pkgs, lib, ... }:
let
  # Helper to get Stylix colors easily
  colors = config.lib.stylix.colors;
  fonts = config.stylix.fonts;
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        ignore_empty_input = true;
        hide_cursor = true;
      };

      # potentially set other wallpaper here
      background = lib.mkForce [
        {
          path = "${config.stylix.image}";
        }
      ];

      label = [
        # TIME
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +\"%-I:%M%p\")\"";
          color = "rgb(${colors.base05})";
          font_size = 95;
          font_family = "${fonts.sansSerif.name} Extrabold";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
        # DATE
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +\"%A, %B %d\")\"";
          color = "rgb(${colors.base05})";
          font_size = 22;
          font_family = "${fonts.sansSerif.name}";
          position = "0, 300";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
