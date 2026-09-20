{ config, lib, ... }:
{
  options.jellyfin = {
    enable = lib.mkEnableOption "jellyfin";

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/data/jellyfin";
    };

    hardwareAcceleration.enable = lib.mkEnableOption "jellyfin hardware acceleration";
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
    };
}
