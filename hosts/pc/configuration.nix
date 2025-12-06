{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/system/default.nix
    ];
  system.stateVersion = "25.05";

  # User Definition
  users.users.jp = {
    isNormalUser = true;
    description = "Jean-Pierre";
    extraGroups = [ "networkmanager" "wheel" "input" ];
  };

  networking.hostName = "jp-pc";

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

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
