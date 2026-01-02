{
  pkgs,
  config,
  ...
}: {
  # mullvad
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  # tailscale
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  services.tailscale.permitCertUid = "jp";
  networking.firewall = {
    checkReversePath = "loose";
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [config.services.tailscale.port];
  };
}
