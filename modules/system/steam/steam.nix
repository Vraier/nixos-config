{ config, pkgs, ... }:

{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    extraCompatPackages = [ pkgs.steam-run ];
  };

  programs.gamemode.enable = true;
  environment.systemPackages = with pkgs; [
    mangohud
  ];
}
