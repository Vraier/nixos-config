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
    enable = true;
    checkReversePath = "loose";
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [config.services.tailscale.port];
  };

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;
}
