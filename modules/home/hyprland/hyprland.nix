{ lib, config, pkgs, ... }: 
{
  config = {

    # 1. Hyprland Config
    wayland.windowManager.hyprland = {
        enable = true;
        settings = {
        monitor = ",preferred,auto-left,1";
        "$mod" = "SUPER";
        "$terminal" = "kitty";
        "$menu" = "rofi -show drun -show-icons";

        exec-once = [
          "waybar"
        ];

        input = {
            kb_layout = "de";
            kb_variant = "us";
            kb_options = "ctrl:nocaps";
            follow_mouse = 1;
        };

        general = {
            gaps_in = 5;
            gaps_out = 10;
            border_size = 2;
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

        bind = [
            "$mod, RETURN, exec, $terminal"
            "$mod, Q, killactive,"
            "$mod, V, togglefloating,"
            "$mod, D, exec, $menu"
            "$mod, P, pseudo," 
            "$mod, J, togglesplit,"
            "$mod, L, exec, hyprlock"
            "$mod, left, movefocus, l"
            "$mod, right, movefocus, r"
            "$mod, up, movefocus, u"
            "$mod, down, movefocus, d"
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

    programs.waybar = {
        enable = true;
        systemd.enable = false;
    };
    
    programs.rofi = {
        enable = true;
    };
    
    programs.kitty = {
        enable = true;
        settings = {
        confirm_os_window_close = 0;
        dynamic_background_opacity = true;
        enable_audio_bell = false;
        mouse_hide_wait = "-1.0";
        window_padding_width = 10;
        background_blur = 5;
        };
    };

    programs.hyprlock.enable = true;
    services.hypridle.enable = true;

    services.dunst = {
      enable = true;
      settings = {
        global = {
          origin = "top-right";
        };
      };
    };

    services.network-manager-applet.enable = true;
  };
}