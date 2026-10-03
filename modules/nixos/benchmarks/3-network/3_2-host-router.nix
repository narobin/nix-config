{ assure, ... }:
{
  options = { };

  config.benchmarks.rules = with assure; [
    {
      rule = "3.2.1";
      name = "source routed packets are not accepted";
      assertion = netIs false "accept_source_route";
    }
    {
      rule = "3.2.2";
      name = "ICMP redirects are not accepted";
      assertion = netIs false "accept_redirects";
    }
    {
      rule = "3.2.3";
      name = "secure ICMP redirects are not accepted";
      assertion = netIs false "secure_redirects";
    }
    {
      rule = "3.2.4";
      name = "suspicious packets are logged";
      assertion = netv4Is true "log_martians";
    }
    {
      rule = "3.2.5";
      name = "broadcast ICMP requests are ignored";
      assertion = netv4Is true "icmp_echo_ignore_broadcasts";
    }
    {
      rule = "3.2.6";
      name = "bogus ICMP responses are ignored";
      assertion = netv4Is true "icmp_ignore_bogus_error_responses";
    }
    {
      rule = "3.2.7";
      name = "Reverse Path Filtering is enabled";
      assertion = netv4Is true "rp_filter";
    }
    {
      rule = "3.2.8";
      name = "TCP SYN Cookies is enabled";
      assertion = sysctlCheck true "net.ipv4.tcp_syncookies";
    }
    {
      rule = "3.2.9";
      name = "ipv6 router advertisements are not accepted";
      assertion = netv6Is false "accept_ra";
    }
  ];
}
