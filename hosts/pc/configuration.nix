{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../common/global.nix
      ../common/users.nix
    ];
  system.stateVersion = "25.05";

  home-manager.users.jp = {
    home.stateVersion = "25.11";
    programs.ssh.matchBlocks."github.com".identityFile = "~/.ssh/nixos-pc";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-361c8378-276e-4a51-92a0-860a425849f6".device = "/dev/disk/by-uuid/361c8378-276e-4a51-92a0-860a425849f6";
  networking.hostName = "jp-pc";
}
