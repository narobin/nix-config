{ ... }:
{
  programs.ssh.extraConfig = ''
    Host *
      CanonicalizeHostname yes
      CanonicalDomains aegean-penny.ts.net
      CanonicalizeMaxDots 0

    Host *.aegean-penny.ts.net
      ForwardAgent yes
      Port 2222

    Host *
      ControlMaster auto
      ControlPath ~/.ssh/cm-%C
      ControlPersist 10m
  '';
}

