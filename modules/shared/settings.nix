{ lib, config, ... }:
{
  options.mySystem.enableGui = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether this host has a GUI (laptop/desktop) or is headless (server).";
  };
}
