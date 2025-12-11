{ config, pkgs, lib, ... }:
let
  c = config.lib.stylix.colors;
in
{
  imports = [
    ./bindings.nix
  ];


  programs.niri.settings = {
    environment."NIXOS_OZONE_WL" = "1";

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
      { command = [ "${pkgs.swww}/bin/swww-daemon" ]; }
      {
        command = [
          "sh"
          "-c"
          "while ! ${pkgs.swww}/bin/swww query; do sleep 0.1; done && ${pkgs.swww}/bin/swww img ${config.stylix.image} --transition-type grow"
        ];
      }
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
        # relative-to = "workspace-view"; # Optional: makes the gradient fixed to screen
      };
    };


    # Appearance
    prefer-no-csd = true;
    window-rules = [
      # Find ids for matching with niri msg pick-window

      # Matches everything
      {
        matches = [ ];

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
        matches = [{ app-id = "^(Alacritty)$"; }];
        opacity = 0.8;
      }

      {
        matches = [{ app-id = "^(Alacritty)$"; is-active = true; }];
        opacity = 1.0;
      }
    ];

    layer-rules = [
      {
        matches = [{ namespace = "^launcher$"; }];
        opacity = 0.9;
      }

      {
        matches = [{ namespace = "^background$"; }];
        place-within-backdrop = true;
      }
    ];

  };

  home.packages = with pkgs; [
    fuzzel # need fuzzle for default niri config
    alacritty # alacritty is default terminal for niri launcher
  ];
}
