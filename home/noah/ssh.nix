{ pkgs, lib, ... }:
let
  onePasswordPath =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\""
    else
      "~/.1password/agent.sock";
in
{
  home.file.".ssh/github.pub".source = ./resources/github.pub;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "github.com" = lib.hm.dag.entryBefore [ "*" ] {
        User = "git";
        IdentityFile = "~/.ssh/github.pub";
        IdentitiesOnly = "yes";
      };

      "*" = {
        IdentityAgent = onePasswordPath;
        IdentitiesOnly = "yes";

        ServerAliveInterval = 60;
        ServerAliveCountMax = 3;
        TCPKeepAlive = "yes";

        HashKnownHosts = "yes";
        UpdateHostKeys = "yes";
        StrictHostKeyChecking = "accept-new";
        HostKeyAlgorithms = "ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-256";
        KexAlgorithms = "curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512";
        MACs = "hmac-sha2-512,hmac-sha2-256";
        Ciphers = "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes256-ctr";
      };
    };
  };
}
