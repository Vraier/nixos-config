{ lib, config, pkgs, inputs, ... }:

{
  config = {
    environment.systemPackages = [
      pkgs.catppuccin-sddm # display manger theme
      pkgs.catppuccin-sddm-corners # display manger theme
    ];

    boot.initrd.kernelModules = [ "amdgpu" ];
    services.xserver.enable = true;
    services.xserver.videoDrivers = [ "amdgpu" ];

    services.displayManager.autoLogin = {
      enable = true;
      user = "jp";
    };


    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      # list themes by: ls /run/current-system/sw/share/sddm/themes
      theme = "catppuccin-mocha-mauve"; # Set the theme here
    };

    #programs.hyprland = {
    #  enable = true;
    #  xwayland.enable = true;
    #};
    
    nixpkgs.overlays = [ inputs.niri.overlays.niri ];
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };


    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
    };
  };
}
