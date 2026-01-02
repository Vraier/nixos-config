{pkgs, ...}: {
  programs.thunar.enable = true;

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";
}
