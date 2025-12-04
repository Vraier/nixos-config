{ lib, config, pkgs, ... }:

{
  config = {
    services.displayManager.sessionPackages = [ pkgs.hyprland ];

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    boot.initrd.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
