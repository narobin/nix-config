{ config, lib, ... }:
{
  options = { };

  config.benchmarks.rules = [
    {
      enable = false;
      rule = "1.3.1";
      name = "AIDE is installed";
      assertion = builtins.elem "aide" config.environment.systemPackages;
    }
    # {
    #   enable = false;
    #   rule = "1.3.2";
    #   name = "filesystem integrity is regularly checked";
    #   assertion: unsure on implementation
    # }
  ];
}
