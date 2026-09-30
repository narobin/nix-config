{ ... }:
{
  imports = [
    ../../modules/nixos
    ../../modules/shared
    ../../home/noah
    ../../home/cabine
  ];

  mySystem.enableGui = false;

  networking.hostName = "servitor";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.05";
}
