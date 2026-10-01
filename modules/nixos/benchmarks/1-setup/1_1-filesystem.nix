{ config, lib, ... }:

let
  bannedFilesystems = [
    {
      module = "cramfs";
      rule = "1.1.1.1";
    }
    {
      module = "freevxfs";
      rule = "1.1.1.2";
    }
    {
      module = "jffs2";
      rule = "1.1.1.3";
    }
    {
      module = "hfs";
      rule = "1.1.1.4";
    }
    {
      module = "hfsplus";
      rule = "1.1.1.5";
    }
    {
      module = "squashfs";
      rule = "1.1.1.6";
    }
    {
      module = "udf";
      rule = "1.1.1.7";
    }
  ];
  kernelModuleDisabled =
    module:
    builtins.elem module config.boot.blacklistedKernelModules
    && !(builtins.elem module config.boot.kernelModules);
  fileMountExists = mount: config.fileSystems ? mount;
  fileMountHasOption =
    option: (mount: fileMountExists mount -> builtins.elem option config.fileSystems.${mount});
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
in
{
  options = { };

  config.benchmarks.rules = [
    {
      # TODO: figure out if and how to enable this
      enable = false;
      rule = "1.1.1.8";
      name = "mounting of FAT filesystems is limited";
      server.level = 2;
      workstation.level = 2;
      assertion = true;
    }
    {
      rule = "1.1.2";
      name = "/tmp is configured a separate partition";
      assertion = mountExists "/tmp";
    }
    {
      rule = "1.1.3";
      name = "nodev option is set on /tmp";
      assertion = mountHasOption "nodev" "/tmp";
    }
    {
      rule = "1.1.4";
      name = "nosuid option is set on /tmp";
      assertion = mountHasOption "nosuid" "/tmp";
    }
    {
      rule = "1.1.5";
      name = "noexec option is set on /tmp";
      assertion = mountHasOption "noexec" "/tmp";
    }
    {
      rule = "1.1.6";
      name = "separate partition exists for /var";
      server.level = 2;
      workstation.level = 2;
      assertion = mountExists "/var";
    }
    {
      rule = "1.1.7";
      name = "separate partition exists for /var/tmp";
      server.level = 2;
      workstation.level = 2;
      assertion = mountExists "/var/tmp";
    }
    {
      rule = "1.1.8";
      name = "nodev option is set on /var/tmp";
      assertion = mountHasOption "nodev" "/var/tmp";
    }
    {
      rule = "1.1.9";
      name = "nosuid option is set on /var/tmp";
      assertion = mountHasOption "nosuid" "/var/tmp";
    }
    {
      rule = "1.1.10";
      name = "noexec option is set on /var/tmp";
      assertion = mountHasOption "noexec" "/var/tmp";
    }
    {
      rule = "1.1.11";
      name = "separate partition exists for /var/log";
      server.level = 2;
      workstation.level = 2;
      assertion = mountExists "/var/log";
    }
    {
      rule = "1.1.12";
      name = "separate partition exists for /var/log/audit";
      server.level = 2;
      workstation.level = 2;
      assertion = mountExists "/var/log/audit";
    }
    {
      rule = "1.1.13";
      name = "separate partition exists for /home";
      server.level = 2;
      workstation.level = 2;
      assertion = mountExists "/home";
    }
    {
      rule = "1.1.14";
      name = "nodev option is set on /home";
      assertion = mountHasOption "nodev" "/home";
    }
    {
      rule = "1.1.15";
      name = "nodev option is set on /dev/shm";
      assertion = mountHasOption "nodev" "/dev/shm";
    }
    {
      rule = "1.1.16";
      name = "nosuid option is set on /dev/shm";
      assertion = mountHasOption "nosuid" "/dev/shm";
    }
    {
      rule = "1.1.17";
      name = "nosuid option is set on /dev/shm";
      assertion = mountHasOption "nosuid" "/dev/shm";
    }
    # 1.1.18 nodev set on removable media partitions
    # 1.1.19 nosuid set on removable media partition
    # 1.1.20 noexec set on removable media partition
    # {
    #   rule = "1.1.21";
    #   name = "sticky bit is set on all world-writable directories";
    #   assertion = builtins.elem ""
    # }
    {
      rule = "1.1.22";
      name = "automounting is disabled";
      assertion = !config.services.autofs.enable;
    }
    {
      rule = "1.1.23";
      name = "usb storage is disabled";
      workstation.level = 2;
      assertion = kernelModuleDisabled "usb-storage";
    }

  ]
  # 1.1.1.1-7 Disable unused filesystems
  ++ (map (item: {
    assertion = kernelModuleDisabled item.module;
    name = "mounting of '${item.module}' file systems is disabled";
    rule = item.rule;
  }) bannedFilesystems);
}
