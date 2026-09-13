{ config, lib, ... }:
{
  options.mac-cleanup = {
    enable = lib.mkEnableOption "macos-cleanup";
  };

  config = lib.mkIf config.mac-cleanup.enable {
    assertions = [ ];

    launchd.daemons.macos-cleanup = {
      
    };
  };
}