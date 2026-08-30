{ ... }:
{
  imports = [
    ../../modules/nixos
    ../../modules/shared
    ../../home/noah
  ];

  mySystem = {
    enableGui = true;
    enableWireless = true;
  };

  networking.hostName = "vrrr.narobin.com";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.05";
}
