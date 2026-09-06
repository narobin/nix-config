{ config, ... }:
{
  networking = {
    firewall = {
      enable = true;
    };

    wireless = {
      enable = config.mySystem.enableWireless;
      secretsFile = config.sops.templates."wifi.env".path;
      networks = {
        "Unit 221".pskRaw = "ext:UNIT_221_PSK";
      };
    };
  };
}
