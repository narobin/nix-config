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

      services.tailscale = {
        enable = true;
        authKeyFile = config.sops.secrets."vrrr/tailscale-key".path;
      };
    };
}
