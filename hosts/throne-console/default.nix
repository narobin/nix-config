{ ... }:
{
  imports = [
    ../../modules/darwin
    ../../modules/shared
    ../../home/cabine
  ];

  system.primaryUser = "cabine";

  networking.hostName = "throne-console.cabine.me";
  networking.localHostName = "throne-console";
  networking.computerName = "Throne Console";
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
}
