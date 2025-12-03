{ lib, config, pkgs, ... }:

{
  config = {
    # 1. Enable Hyprland
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    # 2. Graphics Drivers (AMD)
    boot.initrd.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];
    
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    # 3. Environment Variables
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # 4. Portals (File pickers)
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    environment.systemPackages = with pkgs; [
      waybar               # The bar
      dunst                # Notifications
      libnotify            # The 'notify-send' command
      swww                 # Wallpaper tool
      rofi         # App launcher
      networkmanagerapplet # GUI for wifi
      kitty                # Terminal
      wl-clipboard         # Clipboard command
    ];
  };
}