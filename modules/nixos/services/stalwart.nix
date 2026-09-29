{ config, lib, ... }:
{
  options = {
    services.stalwart = {
      mode = lib.mkOption {
        type = lib.types.enum [
          "tunnel"
        ];
        default = "tunnel";
        description = "method for exposing stalwart to the public internet";
      };
    };
  };

  config =
    let
      cfg = config.services.stalwart;
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.mode == "tunnel" -> config.services.cloudflared.enable;
          message = "cloudflared must be enabled when services.stalwart.mode is set to tunnel";
        }
      ];

      services.stalwart = {
        enable = true;
        dataDir = "/data/stalwart";
      };
    };
}
