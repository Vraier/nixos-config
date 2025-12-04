{ lib, config, pkgs, ... }:

{
  config = {
    programs.waybar = {
      enable = true;
      systemd.enable = false;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          mod = "dock";
          exclusive = true;
          passthrough = false;
          gtk-layer-shell = true;

          modules-left = [
            "hyprland/workspaces"
            "hyprland/window"
          ];
          modules-center = [
            "clock"
          ];
          modules-right = [
            "custom/weather"
            "pulseaudio"
            "network"
            "battery"
            "tray"
          ];

          "hyprland/window" = {
            format = "{}";
            seperate-outputs = true;
          };
          "hyprland/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
            on-click = "activate";
            format = " {name} ";
          };
          "custom/weather" = {
            format = "{}°C";
            tooltip = true;
            interval = 3600;
            exec = "wttrbar --location Karlsruhe";
            return-type = "json";
          };
          tray = {
            icon-size = 13;
            spacing = 10;
          };
          clock = {
            format = " {:%R   %d/%m}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };
        };
      };
    };
  };
}
