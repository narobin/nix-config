{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.services.tailscale = {
    butler = {
      enable = lib.mkEnableOption "Whether to enable the Butler service";
      services = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              https = lib.mkOption {
                type = lib.types.nullOr lib.types.int;
                default = null;
              };
              tcp = lib.mkOption {
                type = lib.types.nullOr lib.types.int;
                default = null;
              };
            };
          }
        );
        default = { };
      };
    };
  };

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
        port = 30002;
      };

      systemd.services.tailscale-butler =
        let
          script = pkgs.writeShellScript "Butler" (
            lib.concatStringsSep "\n" (
              [ "${lib.getExe config.services.tailscale.package} serve reset" ]
              ++ lib.flatten (
                lib.mapAttrsToList (
                  svc: value:
                  (lib.optional (value.https != null)
                    "${lib.getExe config.services.tailscale.package} serve --yes --service=svc:${svc} --https=443 http://localhost:${toString value.https}"
                  )
                  ++ (lib.optional (value.tcp != null)
                    "${lib.getExe config.services.tailscale.package} serve --yes --service=svc:${svc} --tcp=${toString value.tcp} tcp://localhost:${toString value.tcp}"
                  )
                  ++ [ "${lib.getExe config.services.tailscale.package} serve advertise svc:${svc}" ]
                ) cfg.butler.services
              )
            )
          );
        in
        lib.mkIf cfg.butler.enable {
          description = "Tailscale Butler";
          after = [
            "tailscaled.service"
            "tailscaled-autoconnect.service"
            "tailscaled-set.service"
          ];
          wants = [ "tailscaled.service" ];
          wantedBy = [ "multi-user.target" ];

          restartTriggers = [ script ];

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = script;
          };
        };
    };
}
