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
        "Unit 221".psk = "@UNIT_221_PSK@";
      };
    };
  };
}
