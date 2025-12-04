{ lib, config, pkgs, ... }:

{
  config = {
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
