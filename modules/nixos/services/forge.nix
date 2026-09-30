{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.services.forgejo = {
    configureTailscale = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to configure Tailscale to serve Forge.";
    };
    configureKanidm = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to configure Kanidm with Forge oauth2.";
    };
  };

  config =
    let
      cfg = config.services.forgejo;
      runner-cfg = config.services.forgejo-runner;
      secrets = config.sops.secrets;
      srv = cfg.settings.server;
      hostname = "forge.aegean-penny.ts.net";
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.configureTailscale -> config.services.tailscale.enable;
          message = "config.services.tailscale.enable must be true when config.services.forgejo.configureTailscale is true.";
        }
        {
          assertion =
            cfg.configureKanidm
            -> (config.services.kanidm.server.enable && config.services.kanidm.provision.enable);
          message = "config.services.kanidm.server.enable and config.services.kanidm.provision.enable must be true when config.services.forgejo.configureKanidm is true";
        }
      ];

      sops.secrets = {
        "kanidm/forgejo-basic-secret" = {
          owner = "kanidm";
          group = "kanidm";
        };
      };

      services.forgejo = {
        stateDir = "/data/forgejo";
        lfs.enable = true;
        settings = {
          server = {
            DOMAIN = hostname;
            ROOT_URL = "https://${srv.DOMAIN}/";
            HTTP_PORT = 3000;
            SSH_PORT = 22;
          };
          service = {
            DISABLE_REGISTRATION = true;
            ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
            ENABLE_INTERNAL_SIGNIN = false;
            ENABLE_BASIC_AUTHENTICATION = false;
          };
          oauth2_client = {
            ENABLE_AUTO_REGISTRATION = true;
          };
        };
      };

      services.forgejo-runner = { };

      systemd.services.forgejo-serve =
        let
          svc = "forge";
          script = pkgs.writeShellScript "serve ${svc}" ''
            ${lib.getExe config.services.tailscale.package} serve --yes --service=svc:${svc} --https=443 http://localhost:${toString srv.HTTP_PORT}
            ${lib.getExe config.services.tailscale.package} serve --yes --service=svc:${svc} --tcp=22 tcp://localhost:${toString srv.SSH_PORT}
            ${lib.getExe config.services.tailscale.package} serve advertise svc:${svc}
          '';
        in
        {
          description = "Forgejo Serve Configuration";

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
          "forgejo_users" = {
            members = [ "forgejo_admins" ];
          };
          "forgejo_admins" = { };
        };

        systems.oauth2."forgejo" = {
          displayName = "Forgejo";
          preferShortUsername = true;
          originLanding = "https://${hostname}";
          originUrl = [
            "https://${hostname}/user/oauth2/Kanidm/callback"
          ];
          basicSecretFile = secrets."kanidm/forgejo-basic-secret".path;
          scopeMaps."forgejo_users" = [
            "openid"
            "email"
            "profile"
            "ssh_publickeys"
          ];
          claimMaps."forgejo_role" = {
            joinType = "csv";
            valuesByGroup = {
              "forgejo_admins" = [ "admin" ];
            };
          };
        };
      };
    };
}
