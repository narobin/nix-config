{ config, lib, ... }:
{
  options.services.blocky = {

  };

  config =
    let
      cfg = config.services.blocky;
    in
    lib.mkIf cfg.enable {
      services.blocky = {
        settings = {
          ports.dns = 53;
          upstreams.groups.default = [
            "https://one.one.one.one/dns-query"
          ];
          bootstrapDns = {
            upstream = "https://one.one.one.one/dns-query";
            ips = [
              "1.1.1.1"
              "1.0.0.1"
            ];
          };
          blocking = {
            denylists = {
              ads = [
                "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/pro-onlydomains.txt"
              ];
            };
            clientGroupsBlock = {
              default = [
                "ads"
              ];
            };
          };
          caching = {
            minTime = "5m";
            maxTime = "30m";
            prefetching = true;
          };
        };
      };
    };
}
