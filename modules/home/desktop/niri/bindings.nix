{ config, pkgs, lib, ... }:
let
  # Shorten the accessor to the action helpers
  actions = config.lib.niri.actions;

deps = [ pkgs.jq pkgs.niri ];

  # SCRIPT 1: LEFT
  focusLeftAware = pkgs.writeShellScriptBin "focus-left-aware" ''
    # 1. Get the JSON once to avoid race conditions
    JSON=$(${pkgs.niri}/bin/niri msg -j windows)

    # 2. Extract logic using jq
    # We find the focused window, get its Workspace ID ($wid) and Column ($curr).
    # Then we filter ALL windows to find only those on $wid, and get the minimum column value.
    read CURRENT MIN <<< $(echo "$JSON" | ${pkgs.jq}/bin/jq -r '
      (.[] | select(.is_focused)) as $f
      | $f.workspace_id as $wid
      | $f.layout.pos_in_scrolling_layout[0] as $curr
      | [ .[] | select(.workspace_id == $wid) | .layout.pos_in_scrolling_layout[0] ] | min as $min
      | "\($curr) \($min)"
    ')

    # 3. Decision Logic
    if [ "$CURRENT" = "$MIN" ]; then
      ${pkgs.niri}/bin/niri msg action focus-monitor-left
    else
      ${pkgs.niri}/bin/niri msg action focus-column-left
    fi
  '';

  # SCRIPT 2: RIGHT
  focusRightAware = pkgs.writeShellScriptBin "focus-right-aware" ''
    JSON=$(${pkgs.niri}/bin/niri msg -j windows)

    read CURRENT MAX <<< $(echo "$JSON" | ${pkgs.jq}/bin/jq -r '
      (.[] | select(.is_focused)) as $f
      | $f.workspace_id as $wid
      | $f.layout.pos_in_scrolling_layout[0] as $curr
      | [ .[] | select(.workspace_id == $wid) | .layout.pos_in_scrolling_layout[0] ] | max as $max
      | "\($curr) \($max)"
    ')

    if [ "$CURRENT" = "$MAX" ]; then
      ${pkgs.niri}/bin/niri msg action focus-monitor-right
    else
      ${pkgs.niri}/bin/niri msg action focus-column-right
    fi
  '';
in
{
home.packages = [ 
  focusLeftAware
  focusRightAware
    pkgs.jq # Required for the script to work
  ];

  programs.niri.settings = {
    binds = with actions; let
      # Helper to spawn shell commands (replaces spawn-sh)
      sh = cmd: spawn "sh" "-c" cmd;
    in
    {
      # --- System & Information ---
      "Mod+Shift+Slash".action = show-hotkey-overlay;
      # --- Application Spawning ---
      "Mod+T".action = spawn "alacritty";
      "Mod+D".action = spawn "fuzzel";
      "Super+Alt+L".action = spawn "swaylock";

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
      "Mod+V".action = toggle-window-floating;
      "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;
      "Mod+W".action = toggle-column-tabbed-display;

      # --- Focus Movement ---
      "Mod+Left".action.spawn = "focus-left-aware";
      "Mod+Down".action = focus-window-or-workspace-down;
      "Mod+Up".action = focus-window-or-workspace-up;
      "Mod+Right".action.spawn = "focus-right-aware";
      "Mod+H".action.spawn = "focus-left-aware";
      "Mod+J".action = focus-window-or-workspace-down;
      "Mod+K".action = focus-window-or-workspace-up;
      "Mod+L".action.spawn = "focus-right-aware";

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
      "Mod+Shift+R".action = switch-preset-window-height;
      "Mod+Ctrl+R".action = reset-window-height;
      "Mod+Ctrl+F".action = expand-column-to-available-width;

      "Mod+Minus".action = set-column-width "-10%";
      "Mod+Equal".action = set-column-width "+10%";
      "Mod+Shift+Minus".action = set-window-height "-10%";
      "Mod+Shift+Equal".action = set-window-height "+10%";

      # --- Screenshots ---
      "Print".action.screenshot = { show-pointer = false; };
      "Mod+Print".action.screenshot-screen = { show-pointer = false; };
      "Mod+Shift+Print".action.screenshot-window = { };

      # --- Overview ---
      "Mod+O" = {
        action = toggle-overview;
        repeat = false;
      };

      # --- Multimedia Keys ---
      # Volume
      "XF86AudioRaiseVolume" = { allow-when-locked = true; action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; };
      "XF86AudioLowerVolume" = { allow-when-locked = true; action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; };
      "XF86AudioMute" = { allow-when-locked = true; action = sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; };
      "XF86AudioMicMute" = { allow-when-locked = true; action = sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; };

      # Playback
      "XF86AudioPlay" = { allow-when-locked = true; action = sh "playerctl play-pause"; };
      "XF86AudioStop" = { allow-when-locked = true; action = sh "playerctl stop"; };
      "XF86AudioPrev" = { allow-when-locked = true; action = sh "playerctl previous"; };
      "XF86AudioNext" = { allow-when-locked = true; action = sh "playerctl next"; };

      # Brightness
      "XF86MonBrightnessUp" = { allow-when-locked = true; action = sh "brightnessctl --class=backlight set +10%"; };
      "XF86MonBrightnessDown" = { allow-when-locked = true; action = sh "brightnessctl --class=backlight set 10%-"; };

      # --- Scroll Wheel Binds ---
      "Mod+WheelScrollDown" = { cooldown-ms = 150; action = focus-workspace-down; };
      "Mod+WheelScrollUp" = { cooldown-ms = 150; action = focus-workspace-up; };
      "Mod+Ctrl+WheelScrollDown" = { cooldown-ms = 150; action = move-column-to-workspace-down; };
      "Mod+Ctrl+WheelScrollUp" = { cooldown-ms = 150; action = move-column-to-workspace-up; };

      "Mod+WheelScrollRight".action = focus-column-right;
      "Mod+WheelScrollLeft".action = focus-column-left;
      "Mod+Ctrl+WheelScrollRight".action = move-column-right;
      "Mod+Ctrl+WheelScrollLeft".action = move-column-left;

      "Mod+Shift+WheelScrollDown".action = focus-column-right;
      "Mod+Shift+WheelScrollUp".action = focus-column-left;
      "Mod+Ctrl+Shift+WheelScrollDown".action = move-column-right;
      "Mod+Ctrl+Shift+WheelScrollUp".action = move-column-left;

    } // (
      # FIXED LOOP:
      # We bypass the 'actions' helper functions and set the config path directly.
      # This ensures 'move-column-to-workspace' works regardless of helper naming.
      builtins.listToAttrs (builtins.concatLists (builtins.genList
        (x:
          let
            n = x + 1;
            s = toString n;
          in
          [
            # Focus workspace 1-9
            {
              name = "Mod+${s}";
              value = { action.focus-workspace = n; };
            }
            # Move column to workspace 1-9
            {
              name = "Mod+Ctrl+${s}";
              value = { action.move-column-to-workspace = n; };
            }
          ]
        ) 9))
    );
  };
}
