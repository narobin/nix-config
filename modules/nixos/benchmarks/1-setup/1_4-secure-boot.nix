{ config, lib, ... }:
{
  options = { };

  config.benchmarks.rules = [
    # 1.4.1 permissions on bootloader config are configured
    # n/a on nixos (symlinks to store, so maybe do anyway?)
    {
      rule = "1.4.2"; # modified for systemd-boot
      name = "bootloader parameter editing is disabled";
      assertion = !config.boot.loader.systemd-boot.editor;
    }
    {
      rule = "1.4.3";
      name = "ensure authentication for emergency shell";
      assertion = config.boot.initrd.systemd.enable;
    }
    # 1.4.4 interactive boot is not enabled
    # n/a for systemd-boot
  ];
}
