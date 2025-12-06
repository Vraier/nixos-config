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
            separate-outputs = true;
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
          "network" = {
            format-wifi = "  {essid}";
            format-ethernet = "  Connected";
            format-disconnected = "  Disconnected";
            tooltip-format = "{ifname} via {gwaddr}";
            on-click = "nm-connection-editor"; # or your preferred wifi menu
          };
          "battery" = {
            states = {
              # "good" = 95;
              "warning" = 30;
              "critical" = 15;
            };
            format = "{icon}  {capacity}%";
            format-charging = "  {capacity}%";
            format-plugged = "  {capacity}%";
            format-icons = [ "" "" "" "" "" ];
          };
          "pulseaudio" = {
            format = "{icon} {volume}%";
            format-muted = " Muted";
            format-icons = {
              "headphone" = "";
              "hands-free" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "default" = [ "" "" "" ];
            };
            # This is the magic: Clicking the icon opens the mixer
            on-click = "pavucontrol";
          };
          tray = {
            icon-size = 18;
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
