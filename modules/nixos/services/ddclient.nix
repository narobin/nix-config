{ config, lib, ... }:
{
  options.ddns = {
    enable = lib.mkEnableOption "ddns";

    domain = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = "Domain to be updated by ddns";
    };

    interval = lib.mkOption {
      type = lib.types.enum [
        "5m"
        "10m"
        "30m"
        "1h"
        "1d"
      ];
      default = "1h";
      description = "ddns refresh interval";
    };
  };

  config = lib.mkIf config.ddns.enable {
    assertions = [
      {
        assertion = config.ddns.domain != null;
        message = "ddns.domain must be set when ddns.enable is true";
      }
    ];

    services.ddclient = {
      enable = true;
      interval = config.ddns.interval;
      protocol = "cloudflare";
      username = "token";
      passwordFile = config.sops.secrets."cloudflare/token".path;
      domains = [ config.networking.hostName ];
      zone = "narobin.com"; # TODO: also support cabine.me
      ssl = true;

      usev6 = "webv6";
      usev4 = "disabled";
    };
  };

}
