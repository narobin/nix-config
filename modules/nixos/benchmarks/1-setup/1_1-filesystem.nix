{ config, ... }:

let
  bannedFilesystems = [
    {
      module = "cramfs";
      rule = "1.1.1.1";
      server = {
        enable = true;
        level = 1;
      };
      workstation = {
        enable = true;
        level = 1;
      };
    }
    {
      module = "freevxfs";
      rule = "1.1.1.2";
      server = {
        enable = true;
        level = 1;
      };
      workstation = {
        enable = true;
        level = 1;
      };
    }
    {
      module = "jffs2";
      rule = "1.1.1.3";
      server = {
        enable = true;
        level = 1;
      };
      workstation = {
        enable = true;
        level = 1;
      };
    }
    {
      module = "hfs";
      rule = "1.1.1.4";
      server = {
        enable = true;
        level = 1;
      };
      workstation = {
        enable = true;
        level = 1;
      };
    }
    {
      module = "hfsplus";
      rule = "1.1.1.5";
      server = {
        enable = true;
        level = 1;
      };
      workstation = {
        enable = true;
        level = 1;
      };
    }
    {
      module = "squashfs";
      rule = "1.1.1.6";
      server = {
        enable = true;
        level = 1;
      };
      workstation = {
        enable = true;
        level = 1;
      };
    }
    {
      module = "udf";
      rule = "1.1.1.7";
      server = {
        enable = true;
        level = 1;
      };
      workstation = {
        enable = true;
        level = 1;
      };
    }
    {
      module = "vfat";
      rule = "1.1.1.8";
      server = {
        enable = true;
        level = 2;
      };
      workstation = {
        enable = true;
        level = 2;
      };
    }
  ];
in
{
  options = { };

  config = {
    assertions = [

    ]
    # 1.1.1 Disable unused filesystems
    ++ (map (item: {
      assertion =
        builtins.elem item.module config.boot.blacklistedKernelModules
        && !(builtins.elem item.module config.boot.kernelModules);
      message = "CIS Benchmarks Rule ${item.rule} requires kernel module '${item.module}' not be used";
    }) bannedFilesystems);
  };
}
