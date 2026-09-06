{ ... }:
{
  services.openssh = {
    enable = true;
    openFirewall = true;
    hostKeys = [
      {
        type = "ed25519";
        path = "etc/ssh/ssh_host_ed25519_key";
        rounds = 100;
      }
    ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "noah" ];
      MaxAuthTries = 3;
      PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
      X11Forwarding = false;
      UseDns = false;
      StreamLocalBindUnlink = true;
      LoginGraceTime = 30;
      AllowTcpForwarding = "no";
      PermitTunnel = "no";
      GatewayPorts = "no";
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
      LogLevel = "VERBOSE";
      KexAlgorithms = [
        "sntrup761x25519-sha512@openssh.com" # post-quantum hybrid KEX
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group18-sha512"
        "diffie-hellman-group-exchange-sha256"
        "diffie-hellman-group16-sha512"
      ];
      Ciphers = [
        "chacha20-poly1305@openssh.com"
        "aes256-gcm@openssh.com"
        "aes256-ctr"
        "aes128-gcm@openssh.com"
        "aes128-ctr"
      ];
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
      ];
    };
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    bantime = "1h";
    bantime-increment = {
      enable = true;
      maxtime = "1w";
    };
  };
}
