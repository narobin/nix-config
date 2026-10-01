{
  config,
  lib,
  options,
  ...
}:
{
  options = { };

  config.benchmarks.rules =
    let
      timesyncdUsed = config.services.timesyncd.enable;
      chronyUsed = config.services.chrony.enable;
      ntpUsed = config.services.ntp.enable;
      ntpRequiredRestrictions = [
        "kod"
        "nomodify"
        "notrap"
        "nopeer"
        "noquery"
      ];
    in
    [
      # 2.2.1 Time Synchronization
      {
        rule = "2.2.1.1";
        name = "time synchronization is in use";
        assertion = timesyncdUsed || chronyUsed || ntpUsed;
      }
      {
        rule = "2.2.1.2";
        name = "ntp is configured";
        assertion =
          ntpUsed
          -> (
            lib.all (a: lib.elem a config.services.ntp.restrictDefault) ntpRequiredRestrictions
            && (options.networking.timeServers.isDefined || options.services.ntp.servers.isDefined)
          );
        # Already runs as ntp user by default
      }
      {
        rule = "2.2.1.3";
        name = "chrony is configured";
        assertion =
          chronyUsed
          -> (options.networking.timeServers.isDefined || options.services.chrony.servers.isDefined);
        # Already runs as chrony user by default, albeit questionably
      }
      {
        rule = "2.2.1.4";
        name = "systemd-timesyncd is configured";
        assertion =
          timesyncdUsed
          -> (options.networking.timeServers.isDefined || options.services.timesyncd.servers.isDefined);
      }

      {
        rule = "2.2.2";
        name = "x window system is not installed";
        workstation.enable = false;
        assertion = !config.services.xserver.enable;
      }
      {
        rule = "2.2.3";
        name = "avahi server is not enabled";
        assertion = !config.services.avahi.enable;
      }
      {
        rule = "2.2.4";
        name = "CUPS is not enabled";
        workstation.level = 2;
        assertion = !config.services.printing.enable;
      }
      {
        rule = "2.2.5 & 2.2.8";
        name = "DNS/DHCP server is not enabled unnecessarily";
        assertion = !config.services.dnsmasq.enable;
      }
      {
        rule = "2.2.6";
        name = "LDAP server is not enabled unnecessarily";
        assertion = !config.services.openldap.enable;
      }
      {
        rule = "2.2.7";
        name = "NFS and RPC are not enabled unnecessarily";
        assertion = !config.services.nfs.server.enable && !config.services.rpcbind.enable;
      }
      {
        rule = "2.2.9";
        name = "FTP server is not enabled unnecessarily";
        assertion = !config.services.vsftpd.enable;
      }
      {
        rule = "2.2.10";
        name = "HTTP server is not enabled unnecessarily";
        assertion = !config.services.httpd.enable;
      }
      {
        rule = "2.2.11";
        name = "IMAP and POP3 server is not enabled unnecessarily";
        assertion = !config.services.dovecot2.enable;
      }
      {
        rule = "2.2.12";
        name = "Samba is not enabled unnecessarily";
        assertion = !config.services.samba.enable;
      }
      {
        rule = "2.2.13";
        name = "HTTP proxy server is not enabled unnecessarily";
        assertion = !config.services.squid.enable;
      }
      {
        rule = "2.2.14";
        name = "SNMP is not enabled";
        assertion = !config.services.snmpd.enable;
      }
      {
        rule = "2.2.15";
        name = "Mail transfer agent is configured for local-only mode unless mail server";
        assertion =
          config.services.postfix.enable
          -> (
            config.services.postfix.settings.main ? "inet_interfaces"
            && config.services.postfix.settings.main.inet_interfaces == "loopback-only"
          );
      }
      {
        rule = "2.2.16";
        name = "rsync service is not enabled";
        assertion = !config.services.rsync.enable;
      }
      # 2.2.17 NIS Server is not enabled
      # not available on nixos anyway
    ];
}
