{ ... }:
{
  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  
    defaultSopsFile = ../../../secrets/default.yaml;

    sops.secrets."cloudflare/token" = {};

    secrets = {
      "cloudflare/token" = {};
      "wireless/unit_221-psk" = {};
    };

    sops.template."wifi.env" = {
      content = ''
        UNIT_221_PSK=${config.sops.placeholder."wifi/unit-221-psk"}
      '';
  };
}
