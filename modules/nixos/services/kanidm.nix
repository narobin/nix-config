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
          "idm.narobin.com" = "https://localhost:8443";
        };
      };

      services.kanidm.package = pkgs.kanidm_1_11;

      services.kanidm.server = {
        enable = true;
        settings = {
          domain = "narobin.com";
          origin = "https://idm.narobin.com";
          tls_chain = config.sops.secrets."cloudflare/kanidm/certificate".path;
          tls_key = config.sops.secrets."cloudflare/kanidm/private-key".path;
        };
      };
    };
}
