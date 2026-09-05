{ config, ... }:
{
  networking = {
    firewall = {
      enable = true;
    };

    wireless = {
      enable = config.mySystem.enableWireless;
      secretsFile = config.sops.secrets."wifi.env".path;
      networks = {
        "Unit 221".psk = "@UNIT_221_PSK@";
      };
    };
  };
}
