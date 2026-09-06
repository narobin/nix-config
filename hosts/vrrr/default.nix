{ config, ... }:
{
  imports = [
    ../../modules/nixos
    ../../modules/shared
    ../../home/noah
    ./hardware.nix
    ./system.nix
  ];

  mySystem = {
    enableGui = true;
    enableWireless = true;
  };

  config.services.ddns = {
    enable = true;
    domain = "vrrr.narobin.com";
  };

  networking.hostName = "vrrr";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.05";
}
