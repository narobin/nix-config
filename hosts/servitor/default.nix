{ ... }:
{
  imports = [
    ../modules/nixos/core
    ../modules/nixos/security
    ../modules/nixos/services
    ../modules/shared
    ../home/noah
    ../home/cabine
  ];

  mySystem.enableGui = false;

  networking.hostName = "servitor.narobin.com";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = 6;
}
