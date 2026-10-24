{ config, lib, ... }:
{
  options.services.miniflux = {
    configureTailscale = lib.mkEnableOption "configuring miniflux Tailscale service";
    configureKanidm = lib.mkEnableOption "configuring miniflux kanidm OAuth2";
    hostname = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default =
        if config.services.miniflux.configureTailscale then
          "miniflux${config.services.tailscale.domainRoot}"
        else
          null;
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 8080;
    };
  };

  config =
    let
      cfg = config.services.miniflux;
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.hostname != null;
          message = "config.services.miniflux.hostname must be set when miniflux is enabled";
        }
      ];

      services.miniflux = {
        config = lib.mkMerge [
          {
            LISTEN_ADDR = "127.0.0.1:${toString cfg.port}";
          }

          (lib.mkIf cfg.configureKanidm {
            OAUTH2_PROVIDER = "oidc";
            OAUTH2_CLIENT_ID = "miniflux";
            OAUTH2_REDIRECT_URL = "https://${cfg.hostname}/oauth2/oidc/callback";
            OAUTH2_OIDC_DISCOVERY_ENDPOINT = "${config.services.kanidm.server.settings.origin}/oauth2/openid/miniflux";
            OAUTH2_USER_CREATION = 1;
          })
        ];
        adminCredentialsFile = config.sops.templates."miniflux.env".path;
      };

      # systemd.services.miniflux.serviceConfig.Group = "kanidm";

      sops = {
        secrets = {
          "miniflux/admin-username" = { };
          "miniflux/admin-password" = { };
          "kanidm/miniflux-basic-secret" = {
            owner = "kanidm";
            group = "kanidm";
          };
        };

        templates."miniflux.env" = {
          owner = "miniflux";
          group = "miniflux";

          content = ''
            ADMIN_USERNAME=${config.sops.placeholder."miniflux/admin-username"}
            ADMIN_PASSWORD=${config.sops.placeholder."miniflux/admin-password"}
            OAUTH2_CLIENT_SECRET=${config.sops.placeholder."kanidm/miniflux-basic-secret"}
          '';
        };
      };

      services.kanidm.provision = lib.mkIf cfg.configureKanidm {
        groups = {
          "miniflux_users" = { };
        };

        systems.oauth2."miniflux" = {
          displayName = "Miniflux";
          originLanding = "https://${cfg.hostname}";
          originUrl = [
            "https://${cfg.hostname}/oauth2/oidc/callback"
          ];
          basicSecretFile = config.sops.secrets."kanidm/miniflux-basic-secret".path;
          scopeMaps."miniflux_users" = [
            "openid"
            "email"
            "profile"
          ];
        };
      };

      services.tailscale.butler.services.miniflux = lib.mkIf cfg.configureTailscale {
        https = cfg.port;
      };
    };
}
