{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
# TODO: Gamemode, keyboard state (maybe too much), sound controls (play/pause, mpd?),
# powerprofiles
let
  c = config.lib.stylix.colors;
  iconColor = c.base0D;
in {
  config = {
    programs.waybar = {
      enable = true;
      systemd.enable = true; # disable this when using waybar

      style = import ./waybar-style.nix {
        colors = config.lib.stylix.colors;
        fonts = config.stylix.fonts;
      };

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          mod = "dock";
          reload_style_on_change = true;
          exclusive = true;
          passthrough = false;
          gtk-layer-shell = true;

          modules-left = [
            "custom/nixos-logo"
            "group/power"
            "group/hardware"
            "group/connectivity"
            "group/audio"
            "group/misc"
            #"hyprland/window"
          ];
          modules-center = [
            #"hyprland/workspaces"
            "niri/workspaces"
          ];
          modules-right = [
            "group/context"
            "group/power-buttons"
          ];

          "group/context" = {
            orientation = "horizontal";
            modules = [
              "custom/weather"
              "clock"
            ];
          };
          "group/hardware" = {
            orientation = "horizontal";
            modules = [
              "cpu"
              "memory"
              "disk"
            ];
          };
          "group/connectivity" = {
            orientation = "horizontal";
            modules = [
              "network"
              "bluetooth"
            ];
          };
          "group/audio" = {
            orientation = "horizontal";
            modules = [
              "pulseaudio"
              "privacy"
            ];
          };

          "group/power" = {
            orientation = "horizontal";
            modules = [
              "battery"
              "power-profiles-deamon"
              "idle_inhibitor"
            ];
          };

          "group/misc" = {
            orientation = "horizontal";
            modules = [
              "tray"
            ];
          };

          "group/power-buttons" = {
            orientation = "horizontal";
            modules = [
              "custom/lock"
              "custom/reboot"
              "custom/shutdown"
              "custom/logout"
            ];
            drawer = {
              "transition-duration" = 400;
              "transition-left-to-right" = false;
              "children-class" = "not-visible";
            };
          };

          "custom/nixos-logo" = {
            format = "<span color=\"#${iconColor}\"> </span>";
            tooltip = false;
            on-click = "ghostty";
          };

          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
            tooltip-format-activated = "Idle Inhibitor: Active";
            tooltip-format-deactivated = "Idle Inhibitor: Inactive";
          };

          "custom/lock" = {
            format = "  ";
            on-click = "hyprlock";
            tooltip-format = "Lock Screen";
          };
          "custom/reboot" = {
            format = "  ";
            on-click = "systemctl reboot";
            tooltip-format = "Reboot System";
          };
          "custom/shutdown" = {
            format = "  ";
            on-click = "systemctl poweroff";
            tooltip-format = "Shutdown System";
          };
          "custom/logout" = {
            format = "  ";
            on-click = "wlogout";
            tooltip-format = "Logout Session";
          };

          "battery" = {
            states = {
              "warning" = 30;
              "critical" = 15;
            };
            format = "<span color=\"#${iconColor}\">{icon}</span> {capacity}%";
            format-charging = "<span color=\"#${iconColor}\"></span> {capacity}%";
            format-plugged = "<span color=\"#${iconColor}\"></span> {capacity}%";
            format-icons = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
            max-length = 7;
            tooltip-format = "Battery: {capacity}%\nTime left: {timeTo}";
          };
          "power-profiles-deamon" = {
            format = "<span color=\"#${iconColor}\">{icon}</span>";
            format-icons = {
              "default" = "";
              "performance" = "";
              "balanced" = "";
              "power-saver" = "";
            };
            tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          };
          "bluetooth" = {
            format = "󰂯";
            tooltip-format = "Bluetooth: {controller_alias} ({status})";
            tooltip-format-connected = "Bluetooth: {controller_alias}\n\n{device_enumerate}";
            tooltip-format-enumerate-connected = "{device_alias}";
            tooltip-format-enumerate-connected-battery = "{device_alias} {device_battery_percentage}%";
            on-click = "blueman-manager";
          };

          "cpu" = {
            interval = 5;
            format = "<span color=\"#${iconColor}\"></span> {usage}%";
            tooltip = true;
            states = {
              warning = 70;
              critical = 90;
            };
          };
          "memory" = {
            interval = 10;
            format = "<span color=\"#${iconColor}\"></span> {}%";
            tooltip = true;
            tooltip-format = "Memory: {used:0.1f}G/{total:0.1f}G ({percentage}%)";
            states = {
              warning = 70;
              critical = 90;
            };
          };
          "disk" = {
            interval = 30;
            format = "<span color=\"#${iconColor}\">󰆼</span> {percentage_used}%";
            path = "/";
            tooltip = true;
            "tooltip-format" = "Disk: {used} used out of {total} on {path}";
            states = {
              warning = 70;
              critical = 85;
            };
          };

          "hyprland/workspaces" = {
            disable-scroll = true;
            all-outputs = false;
            on-click = "activate";
            format = "{icon}";
            "format-icons" = {
              "1" = "一";
              "2" = "二";
              "3" = "三";
              "4" = "四";
              "5" = "五";
              "6" = "六";
              "7" = "七";
              "8" = "八";
              "9" = "九";
              "10" = "十";
              "default" = "·";
            };
          };
          "niri/workspaces" = {
            format = "{icon} {value}";
            format-icons = {
              #"browser" = "";
              #"code" = "";
              #"chat" = "";
              "active" = "";
              "default" = "";
            };
          };

          "custom/weather" = {
            format = "{}°C";
            tooltip = true;
            interval = 3600;
            exec = "wttrbar --location Karlsruhe";
            return-type = "json";
          };
          "network" = {
            format-wifi = " {essid}";
            format-ethernet = "";
            format-disconnected = "";
            tooltip-format = "{ifname} via {gwaddr}";
            tooltip-format-wifi = "{ifname} {essid} ({signalStrength}%)";
            tooltip-format-ethernet = "{ifname} via {gwaddr}";
            tooltip-format-disconnected = "Disconnected";
            on-click = "nm-connection-editor";
          };

          "pulseaudio" = {
            format = "<span color=\"#${iconColor}\">{icon}</span> {volume}%";
            #format-bluetooth = "<span color=\"#${iconColor}\">{icon} </span> {volume}%";
            format-muted = "<span color=\"#${c.base03}\"></span> {volume}%";
            format-icons = {
              headphone = "";
              phone = "";
              phone-muted = "";
              portable = "";
              car = "";
              default = [
                ""
                ""
                ""
              ];
            };
            # This is the magic: Clicking the icon opens the mixer
            on-click = "pavucontrol";
            on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          };
          "privacy" = {
            icon-spacing = 4;
            icon-size = 18;
            transition-duration = 250;
            modules = [
              {
                type = "screenshare";
                tooltip = true;
                tooltip-icon-size = 24;
              }
              {
                type = "audio-in";
                tooltip = true;
                tooltip-icon-size = 24;
              }
            ];
          };
          "tray" = {
            icon-size = 18;
            spacing = 10;
          };
          "clock" = {
            format = "<span color=\"#${iconColor}\"></span> {:%R  <span color=\"#${iconColor}\"></span> %A, %d. %B, %Y}";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            calendar = {
              mode = "year";
              mode-mon-col = 3;
              weeks-pos = "right";
              on-scroll = 1;
              format = {
                months = "<span color='#${config.lib.stylix.colors.base0A}'><b>{}</b></span>";
                days = "<span color='#${config.lib.stylix.colors.base0B}'><b>{}</b></span>";
                weeks = "<span color='#${config.lib.stylix.colors.base0C}'><b>W{}</b></span>";
                weekdays = "<span color='#${config.lib.stylix.colors.base0D}'><b>{}</b></span>";
                today = "<span color='#${config.lib.stylix.colors.base08}'><b><u>{}</u></b></span>";
              };
            };
            actions = {
              on-click-right = "mode";
              on-scroll-up = "shift_down";
              on-scroll-down = "shift_up";
            };
          };
        };
      };
    };
  };
}
