{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    kanidm.server = {
      enable = lib.mkEnableOption "kanidm-server";

      mode = lib.mkOption {
        type = lib.types.enum [
          "tunnel"
        ];
        default = "tunnel";
        description = "method for exposing kanidm to the public internet";
      };
    };
  };

  config =
    let
      cfg = config.kanidm.server;
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.mode == "tunnel" -> config.services.cloudflared.enable;
          message = "cloudflared must be enabled when kanidm.server.mode is set to tunnel";
        }
      ];

      sops = lib.mkIf (cfg.mode == "tunnel") {
        secrets = {
          "cloudflare/kanidm/account-tag" = { };
          "cloudflare/kanidm/tunnel-secret" = { };
          "cloudflare/kanidm/tunnel-id" = { };
          "cloudflare/kanidm/tunnel-cert" = { };
          "cloudflare/kanidm/certificate" = {
            owner = "kanidm";
            group = "kanidm";
          };
          "cloudflare/kanidm/private-key" = {
            owner = "kanidm";
            group = "kanidm";
          };
          "kanidm/admin-password" = {
            owner = "kanidm";
            group = "kanidm";
          };
          "kanidm/idm-admin-password" = {
            owner = "kanidm";
            group = "kanidm";
          };
          "kanidm/tailscale-basic-secret" = {
            owner = "kanidm";
            group = "kanidm";
          };
        };

        templates."kanidm-tunnel.json" = {
          content = ''
            {
              "AccountTag": "${config.sops.placeholder."cloudflare/kanidm/account-tag"}",
              "TunnelSecret": "${config.sops.placeholder."cloudflare/kanidm/tunnel-secret"}",
              "TunnelID": "${config.sops.placeholder."cloudflare/kanidm/tunnel-id"}"
            }
          '';
        };
      };

      services.cloudflared.tunnels."kanidm" = lib.mkIf (cfg.mode == "tunnel") {
        certificateFile = config.sops.secrets."cloudflare/kanidm/tunnel-cert".path;
        credentialsFile = config.sops.templates."kanidm-tunnel.json".path;
        default = "http_status:404";
        ingress = {
          "idm.narobin.com" = "https://127.0.0.1:8443";
        };
        originRequest = {
          noTLSVerify = true;
        };
      };

      services.kanidm.package = pkgs.kanidmWithSecretProvisioning_1_11;

      services.kanidm.server = {
        enable = true;
        settings = {
          bindaddress = "127.0.0.1:8443";
          domain = "narobin.com";
          origin = "https://idm.narobin.com";
          tls_chain = config.sops.secrets."cloudflare/kanidm/certificate".path;
          tls_key = config.sops.secrets."cloudflare/kanidm/private-key".path;
        };
      };

      services.kanidm.provision = {
        enable = true;

        adminPasswordFile = config.sops.secrets."kanidm/admin-password".path;
        idmAdminPasswordFile = config.sops.secrets."kanidm/idm-admin-password".path;

        groups = {
          "tailnet_users" = { };
          "idm_people_on_boarding" = { };
        };

        persons = {
          "cabine" = {
            displayName = "Zach Rice";
            mailAddresses = [ "cabine@narobin.com" ];
            groups = [
              "tailnet_users"
              "immich_users"
              "forgejo_users"
              "vaultwarden_users"
            ];
          };
          "noah" = {
            displayName = "Noah Robinson";
            mailAddresses = [ "noah@narobin.com" ];
            groups = [
              "tailnet_users"
              "idm_people_on_boarding"
              "immich_admins"
              "forgejo_admins"
              "vaultwarden_users"
            ];
          };
        };

        systems.oauth2 = {
          "tailscale" = {
            displayName = "Tailscale";
            originUrl = "https://login.tailscale.com/a/oauth_response";
            originLanding = "https://login.tailscale.com/";
            basicSecretFile = config.sops.secrets."kanidm/tailscale-basic-secret".path;
            scopeMaps."tailnet_users" = [
              "openid"
              "email"
              "profile"
            ];
          };
        };
      };

    };
}
