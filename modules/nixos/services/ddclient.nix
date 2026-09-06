{ config, ... }:
{
  services.ddclient = {
    enable = true;
    interval = "1h";
    protocol = "cloudflare";
    username = "token";
    passwordFile = config.sops.secrets."cloudflare/token".path;
    domains = [ config.networking.hostName ];
    zone = "narobin.com"; # TODO: also support cabine.me
    ssl = true;

    usev6 = "webv6";
    usev4 = "disabled";
  };
}
