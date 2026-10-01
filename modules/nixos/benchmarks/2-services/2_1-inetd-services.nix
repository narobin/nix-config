{ config, ... }:
{
  options = { };

  config.benchmarks.rules = [
    {
      rule = "2.1";
      name = "xinetd not in use";
      assertion = !config.services.xinetd.enable;
    }
    # 2.1.X - nixos doesn't use inetd
  ];
}
