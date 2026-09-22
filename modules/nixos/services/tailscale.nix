{ config, lib, ... }:
{
  options = { };

  config =
    let
      cfg = config.services.tailscale;
    in
    lib.mkIf cfg.enable {
      sops.secrets."vrrr/tailscale-key" = {
        sopsFile = ../../../secrets/vrrr.yaml;
      };

      networking.firewall = {
        trustedInterfaces = [ config.services.tailscale.interfaceName ];
        allowedUDPPorts = [ config.services.tailscale.port ];
      };

      systemd.services.tailscaled.serviceConfig.Environment = [
        "TS_DEBUG_FIREWALL_MODE=nftables"
      ];

      services.tailscale = {
        authKeyFile = config.sops.secrets."vrrr/tailscale-key".path;
      };
    };
}
