{
  config,
  lib,
  assure,
  ...
}:
{
  options = { };

  config.benchmarks.rules = with assure; [
    # Note I've combined the overlapping rules from 3.5.1 and 3.5.2 into 3.5.1
    # because the benchmark was written for iptables but I'm using nftables
    {
      # note this does the inbound deny but does not implement outbound default deny
      rule = "3.5.1.1";
      name = "default deny policy";
      assertion = !config.networking.firewall.rejectPackets;
    }
    {
      # note this is an anti-spoofing measure but doesn't fully block it
      rule = "3.5.1.2";
      name = "loopback traffic is configured";
      assertion = config.networking.firewall.checkReversePath == true;
    }
    # 3.5.1.3 outbound and established connections are configured
    # 3.5.1.4 firewall rules exist for all open ports
  ];
}
