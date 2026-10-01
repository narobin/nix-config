{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = { };

  config.benchmarks.rules =
    let
      seLinuxEnabled = builtins.elem pkgs.libselinux config.environment.systemPackages;
      appArmorEnabled = config.security.apparmor.enable;
    in
    [
      # 1.6.1 Ensure Mandatory Access Control Software is Installed
      {
        rule = "1.6.1.1";
        name = "SELinux or AppArmor is installed";
        server.level = 2;
        workstation.level = 2;
        assertion = appArmorEnabled || seLinuxEnabled;
      }

      # 1.6.2 Configure SELinux
      {
        rule = "1.6.2.1";
        name = "SELinux not disabled in bootloader configuration";
        server.level = 2;
        workstation.level = 2;
        assertion =
          seLinuxEnabled
          -> (
            !(builtins.elem "selinux=0" config.boot.kernelParams)
            && !(builtins.elem "enforcing=0" config.boot.kernelParams)
          );
      }
      # TODO: rest of 1.6.2
      # Not as well-supported on nixos

      # 1.6.3 Configure AppArmor
      {
        rule = "1.6.3.1";
        name = "AppArmor not disabled in bootloader configuration";
        server.level = 2;
        workstation.level = 2;
        assertion = appArmorEnabled -> !(builtins.elem "apparmor=0" config.boot.kernelParams);
      }
      {
        rule = "1.6.3.2";
        name = "all AppArmor policies are enforcing";
        server.level = 2;
        workstation.level = 2;
        assertion = builtins.all (policy: policy.state == "enforcing") config.security.apparmor.policies;
      }
    ];
}
