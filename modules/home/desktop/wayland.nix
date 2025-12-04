{ lib, config, pkgs, ... }:

{
  config = {
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

    services.dunst = {
      enable = true;
      settings = {
        global = {
          origin = "top-right";
        };
      };
    };

    programs.hyprlock.enable = true;
    services.network-manager-applet.enable = true;

    home.packages = with pkgs; [
      grim
      hyprlock
      qt6.qtwayland
      slurp
      waypipe
      wf-recorder
      wl-mirror
      wl-clipboard
      wlogout
      wtype
      ydotool
      libnotify # 'notify-send' command
      wttrbar
    ];
  };
}
