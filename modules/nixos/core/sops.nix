{ config, lib, ... }:
{
  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    defaultSopsFile = ../../../secrets/default.yaml;

    secrets = {
      "cloudflare/token" = { };
      "wireless/unit_221-psk" = { };
      "noah/password" = {
        neededForUsers = true;
      };
    };

    templates."wifi.env" = lib.mkIf config.mySystem.enableWireless {
      owner = "wpa_supplicant";
      group = "wpa_supplicant";
      mode = "0400";

      content = ''
        UNIT_221_PSK=${config.sops.placeholder."wireless/unit_221-psk"}
      '';
    };
  };
}
