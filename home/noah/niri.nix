{ mySystem, lib, pkgs, ... }:
{
  xdg.configFile = lib.optionalAttrs (mySystem.enableGui && !pkgs.stdenv.hostPlatform.isDarwin) {
    "niri/config.kdl".source = ./resources/niri.kdl;
  };
}