{
  config,
  lib,
  assure,
  ...
}:
{
  options.benchmarks.system.network = {
    isRouter = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether this system is configured as a router";
    };
  };

  config.benchmarks.rules =
    with assure;
    lib.mkIf (!config.benchmarks.system.network.isRouter) [
      {
        rule = "3.1.1";
        name = "IP forwarding is disabled";
        assertion = netIs false "forwarding";
      }
      {
        rule = "3.1.2";
        name = "IP redirect sending is disabled";
        assertion = netIs false "send_redirects";
      }
    ];
}
