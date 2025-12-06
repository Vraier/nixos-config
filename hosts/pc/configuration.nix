{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/system/default.nix
    ];
  system.stateVersion = "25.05";

  # Default config  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-eaa776b1-8128-4f6d-ab32-7c42cc751738".device = "/dev/disk/by-uuid/eaa776b1-8128-4f6d-ab32-7c42cc751738";
  networking.hostName = "jp-pc";


  # User Definition
  users.users.jp = {
    isNormalUser = true;
    description = "Jean-Pierre";
    extraGroups = [ "networkmanager" "wheel" "input" ];
  };


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
}
