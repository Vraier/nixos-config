{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  c = config.lib.stylix.colors;

  slideshow-script = pkgs.writeShellScriptBin "wallpaper-slideshow" ''
    sleep 5
    while true; do
      ${pkgs.waypaper}/bin/waypaper --random
      sleep 600
    done
  '';
in {
  imports = [
    ./bindings.nix
  ];

  programs.niri = {
    package = pkgs.niri-unstable;
  };

  programs.niri.settings = {
    # optain id via `niri msg outputs`
    outputs."DP-1" = {
      position = {
        x = 0;
        y = 0;
      };
    };
    outputs."HDMI-A-1" = {
      position = {
        x = -1920;
        y = 360;
      };
    };
    spawn-at-startup = [
      {command = ["${pkgs.swayosd}/bin/swosd-server"];}
      {command = ["${pkgs.xwayland-satellite}/bin/xwayland-satellite"];}
      {command = ["${pkgs.swww}/bin/swww-daemon"];}
      {command = ["${slideshow-script}/bin/wallpaper-slideshow"];}
    ];

    # Layout
    #gestures.hot-corners.enable = false;
    layout = {
      gaps = 20;
      always-center-single-column = true;
      border.width = 4;
      border.active.gradient = lib.mkForce {
        from = "#${c.base0C}";
        to = "#${c.base0D}";
        angle = 45;
        # relative-to = "workspace-view"; # makes the gradient fixed to screen
      };
    };

    # Appearance
    prefer-no-csd = true;
    window-rules = [
      # Find ids for matching with niri msg pick-window

      # Matches everything
      {
        matches = [];

        geometry-corner-radius = {
          top-left = 0.0;
          top-right = 30.0;
          bottom-left = 30.0;
          bottom-right = 0.0;
        };

        clip-to-geometry = true;
      }

      # Transparency for specific apps
      {
        matches = [{app-id = "^(Ghostty)$";}];
        opacity = 0.8;
      }

      {
        matches = [
          {
            app-id = "^(Ghostty)$";
            is-active = true;
          }
        ];
        opacity = 1.0;
      }

      {
        matches = [{title = "^(Theme Switcher)$";}];
        open-floating = true;
        max-height = 300;
        max-width = 600;
      }
    ];

    layer-rules = [
      {
        matches = [{namespace = "^launcher$";}];
        opacity = 0.9;
      }

      {
        matches = [{namespace = "^background$";}];
        place-within-backdrop = true;
      }
    ];
  };

  home.packages = with pkgs; [
    fuzzel # need fuzzle for default niri config
    alacritty # alacritty is default terminal for niri launcher
    xwayland-satellite # needed for steam
    slideshow-script
    swayosd
  ];
}
