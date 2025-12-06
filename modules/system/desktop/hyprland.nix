{ lib, config, pkgs, ... }:

{
  config = {
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
    };

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
      ];
      config = {
        common = {
          # Use Hyprland portal for screenshots/screencasting
          # Use GTK portal for file pickers (Open/Save dialogs)
          default = [ "hyprland" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        };
      };
    };
  };
}
