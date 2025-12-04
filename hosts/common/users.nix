{ pkgs, inputs, ... }: {
  users.users.jp = {
    isNormalUser = true;
    description = "Jean-Pierre";
    extraGroups = [ "networkmanager" "wheel" "input" ];
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
