{ lib, ... }:
{
  options.mySystem.enableGui = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether this host has a GUI (laptop/desktop) or is headless (server).";
  };

  options.mySystem.enableWireless = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether to enable wireless on this system";
  };
}
