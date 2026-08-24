{ config, pkgs, ... }:
{
  services.ddclient = {
    enable = true;
    interval = "1h";
    protocol = "cloudflare";
    username = "TODO";
    passwordFile = "TODO";
    domains = [ "TODO" ];
    zone = "TODO";
    ssl = true;
  }
}
