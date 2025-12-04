{ pkgs, ... }:

{
  programs.btop = {
    enable = true;
    #settings = {
    #  color_theme = "stylix";
    #  theme_background = false;
    #};
  };

  programs.tealdeer = {
    enable = true;
    enableAutoUpdates = true;
  };
  programs.bat.enable = true;
  programs.fzf.enable = true;
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.helix = {
    enable = true;
    defaultEditor = true;
  };
}
