{ config, pkgs, lib, ... }:
let
  # Shorten the accessor to the action helpers
  actions = config.lib.niri.actions;

  # Cool scripts to move to left column or monitor depending on position
  focusLeftAware = pkgs.writeShellScriptBin "focus-left-aware" ''
    # 1. Get the JSON once to avoid race conditions
    JSON=$(${pkgs.niri}/bin/niri msg -j windows)

    # 2. Extract logic using jq
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
    pkgs.jq
    pkgs.swayosd
  ];

  programs.niri.settings = {

    # --- Start the SwayOSD Daemon ---
    # (Optional if you enabled the systemd service, but safe to keep)
    spawn-at-startup = [
      # { command = [ "${pkgs.swayosd}/bin/swosd-server" ]; }
    ];

    binds = with actions; let
      # Helper to spawn shell commands
      sh = cmd: spawn "sh" "-c" cmd;

      # FIXED HELPER 1: For commands that take a value (Volume, Brightness, Media)
      # Syntax: --flag=value
      osd-set = type: arg: spawn "${pkgs.swayosd}/bin/swayosd-client" "--${type}=${arg}";
    in lib.attrsets.mergeAttrsList
    {
      #"Alt+Tab".action.next-window = { };

      # --- System & Information ---
      "Mod+Shift+Slash".action = show-hotkey-overlay;

      # --- Application Spawning ---
      "Mod+T".action = spawn "alacritty";
      "Mod+D".action = spawn "fuzzel";
      "Super+Alt+L".action = spawn "hyprlock";

      # Paste from history or delete from hisotry
      "Mod+V".action = sh "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy";
      "Mod+Alt+V".action = sh "cliphist list | fuzzel --dmenu | cliphist delete";

      # Sway Notification Center
      "Mod+Shift+N".action = sh "swaync-client -t -sw";
      "Mod+Shift+T".action = spawn "sh" "-c" ''
        THEMES=$(switch-theme --list)
        CHOSEN=$(echo "$THEMES" | fuzzel --dmenu -p " Theme: " --lines 6 --width 20)
        if [ -n "$CHOSEN" ]; then
          kitty --title "Theme Switcher" switch-theme "$CHOSEN"
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

      # --- Multimedia Keys (Integrated with SwayOSD) ---

      # 1. Output Volume
      "XF86AudioRaiseVolume" = { allow-when-locked = true; action = osd-set "output-volume" "raise"; };
      "XF86AudioLowerVolume" = { allow-when-locked = true; action = osd-set "output-volume" "lower"; };
      "XF86AudioMute" = { allow-when-locked = true; action = osd-set "output-volume" "mute-toggle"; };

      # 2. Input Volume (Microphone)
      "XF86AudioMicMute" = { allow-when-locked = true; action = osd-set "input-volume" "mute-toggle"; };

      # 3. Brightness
      "XF86MonBrightnessUp" = { allow-when-locked = true; action = osd-set "brightness" "raise"; };
      "XF86MonBrightnessDown" = { allow-when-locked = true; action = osd-set "brightness" "lower"; };

      # 4. Media Player Controls (Now shows song/icon on screen!)
      # Note: We use "playerctl" as the type, and "play-pause" etc as the argument
      "XF86AudioPlay" = { allow-when-locked = true; action = osd-set "playerctl" "play-pause"; };
      "XF86AudioStop" = { allow-when-locked = true; action = osd-set "playerctl" "stop"; };
      "XF86AudioPrev" = { allow-when-locked = true; action = osd-set "playerctl" "prev"; };
      "XF86AudioNext" = { allow-when-locked = true; action = osd-set "playerctl" "next"; };

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
      "Mod+Ctrl+Shift+WheelScrollUp".action = focus-column-left;

    } // (
      # FIXED LOOP
      builtins.listToAttrs (builtins.concatLists (builtins.genList
        (x:
          let
            n = x + 1;
            s = toString n;
          in
          [
            {
              name = "Mod+${s}";
              value = { action.focus-workspace = n; };
            }
            {
              name = "Mod+Ctrl+${s}";
              value = { action.move-column-to-workspace = n; };
            }
          ]
        ) 9))
    );
  };
}
