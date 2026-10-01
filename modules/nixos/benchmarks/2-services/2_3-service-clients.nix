{ config, ... }:
{
  options = { };

  config.benchmarks.rules = [
    # 2.3.1 NIS client is not installed
    # Not available in nixpkgs
    # 2.3.2 rsh client is not installed
    # Not available in nixpkgs
    # 2.3.3 talk client is not installed
    # Not available in nixkpkgs
    # 2.3.4 telnet client is not installed
    # Not available in nixkpkgs
    # 2.3.5 LDAP client is not installed
    # Unsure
  ];
}
