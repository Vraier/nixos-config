{
  pkgs,
  config,
  ...
}: {
  programs.thunar.enable = true;

  environment.systemPackages = [
    pkgs.iwgtk
  ];
}
