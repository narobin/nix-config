{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = { };

  config.benchmarks.rules = [
    {
      rule = "1.5.1";
      name = "core dumps are restricted";
      assertion =
        config.boot.kernel.sysctl ? "fs.suid_dumpable"
        && config.boot.kernel.sysctl."fs.suid_dumpable" == 0
        && builtins.elem {
          domain = "*";
          item = "core";
          type = "hard";
          value = "0";
        } config.security.pam.loginLimits
        && (
          config.systemd.coredump.enabled
          -> (
            config.systemd.coredump.settings.Storage == "none"
            && config.systemd.coredump.settings.ProcessSizeMax == 0
          )
        );
    }
    # 1.5.2 XD/NX support is enabled
    # Default in modern kernels
    {
      rule = "1.5.3";
      name = "address space layout randomization is enabled";
      assertion =
        config.boot.kernel.sysctl ? "kernel.randomize_va_space"
        && config.boot.kernel.sysctl."kernel.randomize_va_space" == 2;
    }
    {
      rule = "1.5.4";
      name = "prelink is not installed";
      assertion = !(builtins.elem pkgs.prelink config.environment.systemPackages);
    }
  ];
}
