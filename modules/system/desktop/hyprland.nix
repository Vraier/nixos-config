{ lib, config, pkgs, ... }:

{
  config = {
    services.displayManager.enable = true;
    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = "jp";
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    services.xserver.enable = true;
    boot.initrd.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];

    services.displayManager.sessionPackages = [ pkgs.hyprland ];

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
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
        pkgs.xdg-desktop-portal-hyprland
      ];
      config.common.default = "*";
    };
  };
}
