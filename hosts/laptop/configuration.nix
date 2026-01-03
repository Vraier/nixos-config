{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/default.nix
  ];
  system.stateVersion = "25.05";

  home-manager.users.jp = {
    home.stateVersion = "25.11";
    programs.ssh.matchBlocks."github.com".identityFile = "~/.ssh/nixos-LAPTOP";
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.jp = {
      imports = [
        ../../modules/home/default.nix
        ./monitors.nix
      ];
      home.username = "jp";
      home.homeDirectory = "/home/jp";
    };
  };

  # User Definition
  users.users.jp = {
    isNormalUser = true;
    description = "Jean-Pierre";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "video"
    ];
  };
  networking.hostName = "jp-laptop";
  services.power-profiles-daemon.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-b720dd0f-9769-45ca-a734-658d84eb3224".device = "/dev/disk/by-uuid/b720dd0f-9769-45ca-a734-658d84eb3224";
}
