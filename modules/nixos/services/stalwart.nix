{ config, lib, ... }:
{
  options = {
    services.stalwart = {
      configureTunnel = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure Cloudflare Tunnel to serve Stalwart.";
      };
      configureKanidm = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to configure kanidm oauth2 for Stalwart.";
      };
    };
  };

  config =
    let
      cfg = config.services.stalwart;
      secrets = config.sops.secrets;
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.configureTunnel -> config.services.cloudflared.enable;
          message = "cloudflared must be enabled when services.stalwart.configureTunnel is set to true";
        }
        {
          assertion =
            cfg.configureKanidm
            -> (config.services.kanidm.server.enable && config.services.kanidm.provision.enable);
          message = "kanidm server and provision must be enabled when services.stalwart.configureKanidm is set to true.";
        }
      ];

      services.stalwart = {
        enable = true;
        dataDir = "/data/stalwart";
      };
    };
}
