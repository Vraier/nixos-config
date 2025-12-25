{
  config,
  pkgs,
  lib,
  ...
}: let
  actions = config.lib.niri.actions;
  audioSwitch = import ../../../../scripts/audio-switch.nix {inherit pkgs;};
  osRebuild = import ../../../../scripts/os-rebuild.nix {inherit pkgs;};
in {
  home.packages = [
    audioSwitch
    osRebuild
  ];
  programs.niri.settings = {
    spawn-at-startup = [
      # { command = [ "${pkgs.swayosd}/bin/swosd-server" ]; }
    ];

    binds = with actions; let
      # Helper to spawn shell commands
      sh = cmd: spawn "sh" "-c" cmd;

      # To display SwayOSD notifications for multimedia keys
      osd-set = type: arg: spawn "${pkgs.swayosd}/bin/swayosd-client" "--${type}=${arg}";
    in
      {
        #"Alt+Tab".action.next-window = { };

        # --- System & Information ---
        "Mod+Shift+Slash".action = show-hotkey-overlay;

        # --- Application Spawning ---
        "Mod+Return".action = spawn "ghostty";
        "Mod+Space".action = spawn "fuzzel";
        "Super+Alt+L".action = spawn "hyprlock";

        # Paste from history or delete from hisotry
        "Mod+V".action = sh "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy";
        "Mod+Alt+V".action = sh "cliphist list | fuzzel --dmenu | cliphist delete";
        "Mod+Alt+V".hotkey-overlay.title = "Paste from Clipboard History";

        # Switch output device for audio
        "Mod+P".action = spawn "audio-switch";
        "Mod+P".hotkey-overlay.title = "Switch Audio Output";
        "Mod+Shift+R".action = spawn "ghostty" "--title=Rebuild" "-e" "os-rebuild";
        "Mod+Shift+R".hotkey-overlay.title = "Rebuild System";

        # Sway Notification Center
        "Mod+Shift+N".action = sh "swaync-client -t -sw";
        "Mod+T".action = spawn "sh" "-c" ''
          THEMES=$(switch-theme --list)
          CHOSEN=$(echo "$THEMES" | fuzzel --dmenu -p " Theme: " --lines 6 --width 20)
          if [ -n "$CHOSEN" ]; then
            ghostty --title="Theme Switcher" -e switch-theme "$CHOSEN"
          fi
        '';

        # --- Session Management ---
        "Mod+Shift+E".action = quit;
        "Ctrl+Alt+Delete".action = quit;
        "Mod+Shift+P".action = power-off-monitors;

        # Escape hatch for remote desktops/VMs
        "Mod+Escape" = {
          action = toggle-keyboard-shortcuts-inhibit;
          allow-inhibiting = false;
        };

        # --- Window Management ---
        "Mod+Q".action = close-window;
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+C".action = center-column;
        "Mod+Ctrl+C".action = center-visible-columns;

        # Floating / Tiling
        "Mod+Shift+V".action = toggle-window-floating;
        #"Mod+V".action = toggle-window-floating;
        #"Mod+Shift+V".action = switch-focus-between-floating-and-tiling;
        "Mod+W".action = toggle-column-tabbed-display;

        # --- Focus Movement ---
        "Mod+Left".action = focus-column-or-monitor-left;
        "Mod+Down".action = focus-window-or-workspace-down;
        "Mod+Up".action = focus-window-or-workspace-up;
        "Mod+Right".action = focus-column-or-monitor-right;
        "Mod+H".action = focus-column-or-monitor-left;
        "Mod+J".action = focus-window-or-workspace-down;
        "Mod+K".action = focus-window-or-workspace-up;
        "Mod+L".action = focus-column-or-monitor-right;

        "Mod+Home".action = focus-column-first;
        "Mod+End".action = focus-column-last;

        # --- Window Movement ---
        "Mod+Ctrl+Left".action = move-column-left-or-to-monitor-left;
        "Mod+Ctrl+Down".action = move-window-down;
        "Mod+Ctrl+Up".action = move-window-up;
        "Mod+Ctrl+Right".action = move-column-right-or-to-monitor-right;
        "Mod+Ctrl+H".action = move-column-left-or-to-monitor-left;
        "Mod+Ctrl+J".action = move-window-down;
        "Mod+Ctrl+K".action = move-window-up;
        "Mod+Ctrl+L".action = move-column-right-or-to-monitor-right;

        "Mod+Ctrl+Home".action = move-column-to-first;
        "Mod+Ctrl+End".action = move-column-to-last;

        # --- Monitor Focus ---
        "Mod+Shift+Left".action = focus-monitor-left;
        "Mod+Shift+Down".action = focus-monitor-down;
        "Mod+Shift+Up".action = focus-monitor-up;
        "Mod+Shift+Right".action = focus-monitor-right;
        "Mod+Shift+H".action = focus-monitor-left;
        "Mod+Shift+J".action = focus-monitor-down;
        "Mod+Shift+K".action = focus-monitor-up;
        "Mod+Shift+L".action = focus-monitor-right;

        # --- Monitor Movement ---
        "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
        "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
        "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
        "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
        "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;

        # --- Workspace Management ---
        "Mod+Page_Down".action = focus-workspace-down;
        "Mod+Page_Up".action = focus-workspace-up;
        "Mod+U".action = focus-workspace-down;
        "Mod+I".action = focus-workspace-up;

        "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;
        "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;
        "Mod+Ctrl+U".action = move-column-to-workspace-down;
        "Mod+Ctrl+I".action = move-column-to-workspace-up;

        "Mod+Shift+Page_Down".action = move-workspace-down;
        "Mod+Shift+Page_Up".action = move-workspace-up;
        "Mod+Shift+U".action = move-workspace-down;
        "Mod+Shift+I".action = move-workspace-up;

        # --- Column/Window Consumption ---
        "Mod+BracketLeft".action = consume-or-expel-window-left;
        "Mod+BracketRight".action = consume-or-expel-window-right;
        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;

        # --- Sizing ---
        "Mod+R".action = switch-preset-column-width;
        #"Mod+Shift+R".action = switch-preset-window-height;
        "Mod+Ctrl+R".action = reset-window-height;
        "Mod+Ctrl+F".action = expand-column-to-available-width;

        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Equal".action = set-window-height "+10%";

        # Screenshots
        "Print".action.screenshot = {
          show-pointer = false;
        };
        "Mod+Print".action.screenshot-screen = {
          show-pointer = false;
        };
        "Mod+Shift+Print".action.screenshot-window = {};

        "Mod+O" = {
          action = toggle-overview;
          repeat = false;
        };

        # Output Volume
        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action = osd-set "output-volume" "raise";
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action = osd-set "output-volume" "lower";
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          action = osd-set "output-volume" "mute-toggle";
        };

        # Microphone
        "XF86AudioMicMute" = {
          allow-when-locked = true;
          action = osd-set "input-volume" "mute-toggle";
        };

        # Brightness
        "XF86MonBrightnessUp" = {
          allow-when-locked = true;
          action = osd-set "brightness" "raise";
        };
        "XF86MonBrightnessDown" = {
          allow-when-locked = true;
          action = osd-set "brightness" "lower";
        };

        # Media Player Controls
        "XF86AudioPlay" = {
          allow-when-locked = true;
          action = osd-set "playerctl" "play-pause";
        };
        "XF86AudioStop" = {
          allow-when-locked = true;
          action = osd-set "playerctl" "stop";
        };
        "XF86AudioPrev" = {
          allow-when-locked = true;
          action = osd-set "playerctl" "prev";
        };
        "XF86AudioNext" = {
          allow-when-locked = true;
          action = osd-set "playerctl" "next";
        };

        # Scroll Wheel Binds
        #"Mod+WheelScrollDown" = {
        #  cooldown-ms = 150;
        #  action = focus-workspace-down;
        #};
        #"Mod+WheelScrollUp" = {
        #  cooldown-ms = 150;
        #  action = focus-workspace-up;
        #};
        #"Mod+Ctrl+WheelScrollDown" = {
        #  cooldown-ms = 150;
        #  action = move-column-to-workspace-down;

        #};
        #"Mod+Ctrl+WheelScrollUp" = {
        #  cooldown-ms = 150;
        #  action = move-column-to-workspace-up;
        #};

        #"Mod+WheelScrollRight".action = focus-column-right;
        #"Mod+WheelScrollLeft".action = focus-column-left;
        #"Mod+Ctrl+WheelScrollRight".action = move-column-right;
        #"Mod+Ctrl+WheelScrollLeft".action = move-column-left;

        #"Mod+Shift+WheelScrollDown".action = focus-column-right;
        #"Mod+Shift+WheelScrollUp".action = focus-column-left;
        #"Mod+Ctrl+Shift+WheelScrollDown".action = move-column-right;
        #"Mod+Ctrl+Shift+WheelScrollUp".action = focus-column-left;
      }
      // (builtins.listToAttrs (
        builtins.concatLists (
          builtins.genList (
            x: let
              n = x + 1;
              s = toString n;
            in [
              {
                name = "Mod+${s}";
                value = {
                  action.focus-workspace = n;
                };
              }
              {
                name = "Mod+Ctrl+${s}";
                value = {
                  action.move-column-to-workspace = n;
                };
              }
            ]
          )
          9
        )
      ));
  };
}
