{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/system/default.nix
    ];
  system.stateVersion = "25.05";

  home-manager.users.jp = {
    home.stateVersion = "25.11";
    programs.ssh.matchBlocks."github.com".identityFile = "~/.ssh/nixos-pc";
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.jp = {
      imports =
        [
          ../../modules/home/default.nix
        ];
      home.username = "jp";
      home.homeDirectory = "/home/jp";
    };
  };

  # User Definition
  users.users.jp = {
    isNormalUser = true;
    description = "Jean-Pierre";
    extraGroups = [ "networkmanager" "wheel" "input" "video" ];
  };
  networking.hostName = "jp-pc";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-361c8378-276e-4a51-92a0-860a425849f6".device = "/dev/disk/by-uuid/361c8378-276e-4a51-92a0-860a425849f6";

  fileSystems = {
    "/mnt/data1" = {
      device = "/dev/disk/by-label/data1";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "compress=zstd" ];
      neededForBoot = false;
    };
    "/mnt/data2" = {
      device = "/dev/disk/by-label/data2";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "compress=zstd" ];
      neededForBoot = false;
    };
  };
}
