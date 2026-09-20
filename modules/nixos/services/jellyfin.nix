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

    tailscale.enable = lib.mkEnableOption "tailscale-jellyfin-serve";
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
          assertion = cfg.tailscale.enable -> config.services.tailscale.enable == true;
          message = "services.tailscale.enable must be true when jellyfin.tailscale.enable is true";
        }
        {
          assertion = cfg.tailscale.enable -> config.services.tailscale.serve.enable == true;
          message = "services.tailscale.serve.enable must be true when jellyfin.tailscale.enable is true";
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

      services.tailscale.serve.services."jellyfin" = lib.mkIf config.services.tailscale.enable {
        endpoints = {
          "tcp:443" = "http://localhost:8096";
        };
        advertised = true;
      };

      systemd.services.advertise-jellyfin = {
        description = "Advertise and enable TLS for svc:jellyfin";
        after = [ "tailscaled.service" ];
        bindsTo = [ "tailscaled.service" ];
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.tailscale ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeShellScript "advertise-jellyfin" ''
            tailscale serve --yes --service=svc:jellyfin --https=443 http://localhost:8096
            tailscale serve advertise svc:jellyfin
          '';
        };
      };

    };
}
