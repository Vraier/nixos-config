{ lib, config, pkgs, ... }:
{
  config = {

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        monitor = ",preferred,auto-left,1";
        "$mod" = "SUPER";
        "$terminal" = "ghostty";
        "$menu" = "rofi -show drun -show-icons";

        exec-once = [
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_ID"
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
          "waybar"
        ];

        input = {
          kb_layout = "de";
          kb_variant = "us";
          kb_options = "ctrl:nocaps";
          follow_mouse = 0;
        };

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 3;
          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };
        };

        windowrule = [
          "workspace $ws1, class:(firefox)"
          "workspace $ws9, class:(steam)"
          "workspace $ws10, class:(Signal)|(discord)|(TelegramDesktop)"
        ];

        bind = [
          "$mod, RETURN, exec, $terminal"
          "$mod, Q, killactive,"
          "$mod, V, togglefloating,"
          "$mod, D, exec, $menu"
          "$mod, L, exec, hyprlock"
          "$mod, E, exec, loginctl terminate-session self"
          "$mod, F, fullscreen,"

          "$mod, COMMA, movecurrentworkspacetomonitor, l"
          "$mod, PERIOD, movecurrentworkspacetomonitor, r"

          "$mod, J, movefocus, l"
          "$mod, K, movefocus, k"
          "$mod, B, movefocus, d"
          "$mod, O, movefocus, u"
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          "$mod SHIFT, J, movewindow, l"
          "$mod SHIFT, K, movewindow, r"
          "$mod SHIFT, B, movewindow, u"
          "$mod SHIFT, O, movewindow, d"
          "$mod SHIFT, left, movewindow, l"
          "$mod SHIFT, down, movewindow, d"
          "$mod SHIFT, up, movewindow, u"
          "$mod SHIFT, right, movewindow, r"

          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"
        ];

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
    };
  };
}
