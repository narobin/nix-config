{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.jellyfin = {
    enable = lib.mkEnableOption "jellyfin";

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/data/jellyfin";
    };

    hardwareAcceleration.enable = lib.mkEnableOption "jellyfin hardware acceleration";

    configureTailscale = lib.mkEnableOption "tailscale-jellyfin-serve";
  };

  config =
    let
      cfg = config.jellyfin;
    in
    lib.mkIf config.jellyfin.enable {
      assertions = [
        {
          assertion = cfg.hardwareAcceleration.enable -> config.mySystem.renderDevice != null;
          message = "mySystem.renderDevice must be set when hardware acceleration is true";
        }
        {
          assertion =
            cfg.configureTailscale
            -> config.services.tailscale.enable && config.services.tailscale.butler.enable;
          message = "services.tailscale.enable must be true when jellyfin.tailscale.enable is true";
        }
        # {
        #   assertion = cfg.tailscale.enable -> config.services.tailscale.serve.enable == true;
        #   message = "services.tailscale.serve.enable must be true when jellyfin.tailscale.enable is true";
        # }
      ];

      services.jellyfin = {
        enable = true;
        openFirewall = true;

        dataDir = cfg.dataDir;

        hardwareAcceleration = {
          enable = cfg.hardwareAcceleration.enable;

          device = config.mySystem.renderDevice;
        };
      };

      services.tailscale.butler.services.jellyfin = lib.mkIf cfg.configureTailscale {
        https = 8096;
      };

    };
}
