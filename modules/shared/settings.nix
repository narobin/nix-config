{ lib, ... }:
{
  options = {
    mySystem = {
      enableGui = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether this host has a GUI (laptop/desktop) or is headless (server).";
      };

      enableWireless = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable wireless on this system";
      };

      renderDevice = lib.mkOption {
        type = lib.types.str;
        default = null;
        description = "The /dev/dri path to the primary rendering device, if available";
      };
    };
  };
}
