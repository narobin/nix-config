{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.services.vaultwarden = {
    configureTailscale = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to configure Tailscale to serve Vaultwarden.";
    };
    configureKanidm = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to configure Kanidm with Vaultwarden oauth2.";
    };
  };

  config =
    let
      cfg = config.services.vaultwarden;
      hostname = "vault.aegean-penny.ts.net";
      idmHostname = "idm.narobin.com";
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.configureTailscale -> config.services.tailscale.enable;
          message = "config.services.tailscale.enable must be true when config.services.vaultwarden.configureTailscale is true.";
        }
        {
          assertion =
            cfg.configureKanidm
            -> (config.services.kanidm.server.enable && config.services.kanidm.provision.enable);
          message = "config.services.kanidm.server.enable and config.services.kanidm.provision.enable must be true when config.services.vaultwarden.configureKanidm is true";
        }
      ];

      sops = {
        secrets = {
          "kanidm/vaultwarden-basic-secret" = {
            owner = "kanidm";
            group = "kanidm";
          };
        };
        templates."vaultwarden.env" = {
          owner = "vaultwarden";
          group = "vaultwarden";

          content = ''
            SSO_CLIENT_SECRET=${config.sops.placeholder."kanidm/vaultwarden-basic-secret"}
          '';
        };
      };

      services.vaultwarden = {
        config = {
          # Hosting
          DOMAIN = "https://${hostname}";
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = 8000;

          # Data
          TRASH_AUTO_DELETE_DAYS = 30;

          # Auth
          SSO_ENABLED = true;
          SSO_ONLY = true;
          SSO_AUTHORITY = "https://${idmHostname}/oauth2/openid/vaultwarden";
          SSO_CLIENT_ID = "vaultwarden";
        };
        # // lib.mkIf cfg.configureKanidm {
        # };
        environmentFile = config.sops.templates."vaultwarden.env".path;
      };

      systemd.services.vaultwarden-serve =
        let
          svc = "vault";
          script = pkgs.writeShellScript "serve ${svc}" ''
            ${lib.getExe config.services.tailscale.package} serve --yes --service=svc:${svc} --https=443 http://${cfg.config.ROCKET_ADDRESS}:${toString cfg.config.ROCKET_PORT}
            ${lib.getExe config.services.tailscale.package} serve advertise svc:${svc}
          '';
        in
        lib.mkIf cfg.configureTailscale {
          description = "Vault Serve Configuration";

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

      services.kanidm.provision = lib.mkIf cfg.configureKanidm {
        groups = {
          "vaultwarden_users" = { };
        };

        systems.oauth2."vaultwarden" = {
          displayName = "vaultwarden";
          preferShortUsername = true;
          originLanding = "https://${hostname}";
          originUrl = [
            "https://${hostname}/identity/connect/oidc-signin"
          ];
          basicSecretFile = config.sops.secrets."kanidm/vaultwarden-basic-secret".path;
          scopeMaps."vaultwarden_users" = [
            "openid"
            "email"
            "profile"
          ];
        };
      };
    };
}
