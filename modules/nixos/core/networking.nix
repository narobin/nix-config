{ config, ... }:
{
  networking = {
    firewall = {
      enable = true;
    };

    wireless = {
      enable = config.mySystem.enableWireless;
      secretsFile = config.sops.secrets.networking.path;
      networks."Unit 221".pskRaw = "ext:UNIT_221";
    };
  };
}
