{ lib, config, pkgs, ... }:

{
  config = {
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

    # clipboard history
    services.cliphist = {
      enable = true;
      allowImages = true;
    };
    
    # nice display for volume changes and brightness changes (integrated into niri bindings)
    services.swayosd = {
      enable = true;
      topMargin = 0.08;
    };


    programs.hyprlock.enable = true;
    services.network-manager-applet.enable = true;

    home.packages = with pkgs; [
      qt6.qtwayland
      qt5.qtwayland
      swaynotificationcenter  # nice notification center for wayland
      polkit_gnome            # answer root password queries 
      wl-clipboard            
      cliphist
      libnotify               # 'notify-send' command
      wttrbar                 # for weather widget
      swww                    # for wallpaper setting
      waypaper                # for pickking wallpapers
      #nh                    # nix shell helper   
    ];
  };
}
