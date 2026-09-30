{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.services.immich = {
    configureTailscale = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to configure Tailscale to serve Immich.";
    };
    configureKanidm = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to configure Kanidm with Immich oauth2.";
    };
  };

  config =
    let
      cfg = config.services.immich;
      secrets = config.sops.secrets;
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.configureTailscale -> config.services.tailscale.enable;
          message = "config.services.tailscale.enable must be true when config.services.immich.configureTailscale is true.";
        }
        {
          assertion =
            cfg.configureKanidm
            -> (config.services.kanidm.server.enable && config.services.kanidm.provision.enable);
          message = "config.services.kanidm.server.enable and config.services.kanidm.provision.enable must be true when config.services.immich.configureKanidm is true";
        }
      ];

      sops.secrets = lib.mkIf cfg.configureKanidm {
        "kanidm/immich-basic-secret" = {
          group = "kanidm";
          mode = "0440";
        };
      };

      services.immich = {
        group = "kanidm";
        settings = {
          oauth = {
            enabled = true;
            autoLaunch = true;
            autoRegister = true;
            clientId = "immich";
            clientSecret._secret = secrets."kanidm/immich-basic-secret".path;
            issuerUrl = "https://idm.narobin.com/oauth2/openid/immich";
            signingAlgorithm = "ES256";
            defaultStorageQuota = 30;
            storageQuotaClaim = "immich_quota";
            roleClaim = "immich_role";
          };
          passwordLogin = {
            enabled = false;
          };
        };
      };

      # services.tailscale.serve.services."capture" = lib.mkIf cfg.configureTailscale {
      #   endpoints = {
      #     "https:443" = "http://${cfg.host}:${toString cfg.port}";
      #   };
      #   advertised = true;
      # };

      systemd.services.immich-serve =
        let
          svc = "capture";
          script = pkgs.writeShellScript "serve ${svc}" ''
            ${lib.getExe config.services.tailscale.package} serve --yes --service=svc:${svc} --https=443 http://${cfg.host}:${toString cfg.port}
            ${lib.getExe config.services.tailscale.package} serve advertise svc:${svc}
          '';
        in
        {
          description = "Immich Serve Configuration";

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

      services.kanidm.provision =
        let
          hostname = "capture.aegean-penny.ts.net";
        in
        lib.mkIf cfg.configureKanidm {
          groups = {
            "immich_users" = {
              members = [ "immich_admins" ];
            };
            "immich_admins" = { };
          };

          systems.oauth2."immich" = {
            displayName = "Immich";
            originLanding = "https://${hostname}";
            originUrl = [
              "https://${hostname}/auth/login"
              "https://${hostname}/user-settings"
              "app.immich:///oauth-callback"
            ];
            basicSecretFile = secrets."kanidm/immich-basic-secret".path;
            scopeMaps."immich_users" = [
              "openid"
              "email"
              "profile"
            ];
            claimMaps."immich_role" = {
              joinType = "csv";
              valuesByGroup = {
                "immich_admins" = [ "admin" ];
              };
            };
            claimMaps."immich_quota" = {
              joinType = "csv";
              valuesByGroup = {
                "immich_admins" = [ "0" ];
                "immich_users" = [ "100" ];
              };
            };
          };
        };
    };
}
