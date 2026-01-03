{
  pkgs,
  config,
  ...
}: {
  programs.thunar.enable = true;

  networking.networkmanager.wifi.backend = "iwd";
  environment.systemPackages = [
    pkgs.iwgtk
  ];
}
