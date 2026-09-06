{ ... }:
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

  networking.hostName = "vrrr";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.05";
}
