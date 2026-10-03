{
  config,
  lib,
  assure,
  ...
}:
{
  _module.args.assure =
    let
      sysctl = config.boot.kernel.sysctl;
    in
    with assure;
    {
      sysctlCheck = value: path: (sysctl ? ${path}) && sysctl.${path} == value;
      netv4Is =
        value: option:
        sysctlCheck value "net.ipv4.conf.all.${option}"
        && sysctlCheck value "net.ipv4.conf.default.${option}";
      netv6Is =
        value: option:
        sysctlCheck value "net.ipv6.conf.all.${option}"
        && sysctlCheck value "net.ipv6.conf.default.${option}";
      netIs = value: option: netv4Is value option && netv6Is value option;
      kernelModuleDisabled =
        module:
        builtins.elem module config.boot.blacklistedKernelModules
        && !(builtins.elem module config.boot.kernelModules);
      fileMountExists = mount: config.fileSystems ? mount;
      fileMountHasOption =
        option: (mount: afileMountExists mount -> builtins.elem option config.fileSystems.${mount});
      systemdMountExists =
        mountLocation: lib.any (mount: mount.where == mountLocation) config.systemd.mounts;
      systemdMountHasOption =
        option:
        (
          mountLocation:
          systemdMountExists mountLocation
          -> (lib.any (
            mount: (mount.where == mountLocation && lib.hasInfix option mount.mountConfig.Options)
          ) config.systemd.mounts)
        );
      mountExists = mount: lib.xor (fileMountExists mount) (systemdMountExists mount);
      mountHasOption =
        option: (mount: fileMountHasOption option mount && systemdMountHasOption option mount);
    };
}
