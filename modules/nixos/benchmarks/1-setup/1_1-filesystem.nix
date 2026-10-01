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
in
{
  options = { };

  config = {
    benchmarks.rules = [
      {
        # TODO: figure out if and how to enable this
        enable = false;
        rule = "1.1.1.8";
        name = "mounting of FAT filesystems is limited";
        assertion = true;
        workstation.level = 2;
        server.level = 2;
      }
      {
        rule = "1.1.2";
        name = "/tmp is configured as tmpfs or a partition";
        assertion = lib.xor (
          config.boot.tmp.useTmpfs && lib.any (mount: mount.where == "/tmp") config.systemd.mounts
        ) (config.fileSystems ? "/tmp");
      }
      {
        rule = "1.1.3";
        name = "nodev option is set on /tmp";
        assertion =
          (
            config.boot.tmp.useTmpfs
            -> lib.any (
              mount: mount.where == "/tmp" && lib.hasInfix "nodev" mount.mountConfig.Options
            ) config.systemd.mounts
          )
          && (config.fileSystems ? "/tmp" -> builtins.elem "nodev" config.fileSystems."/tmp".options);
      }
      {
        rule = "1.1.4";
        name = "nosuid option is set on /tmp";
        assertion =
          (
            config.boot.tmp.useTmpfs
            -> lib.any (
              mount: mount.where == "/tmp" && lib.hasInfix "nosuid" mount.mountConfig.Options
            ) config.systemd.mounts
          )
          && (config.fileSystems ? "/tmp" -> builtins.elem "nosuid" config.fileSystems."/tmp".options);
      }
      {
        rule = "1.1.5";
        name = "noexec option is set on /tmp";
        assertion =
          (
            config.boot.tmp.useTmpfs
            -> lib.any (
              mount: mount.where == "/tmp" && lib.hasInfix "noexec" mount.mountConfig.Options
            ) config.systemd.mounts
          )
          && (config.fileSystems ? "/tmp" -> builtins.elem "noexec" config.fileSystems."/tmp".options);
      }
    ]
    # 1.1.1.1-7 Disable unused filesystems
    ++ (map (item: {
      assertion =
        builtins.elem item.module config.boot.blacklistedKernelModules
        && !(builtins.elem item.module config.boot.kernelModules);
      name = "mounting of '${item.module}' is disabled";
      rule = item.rule;
    }) bannedFilesystems);
  };
}
