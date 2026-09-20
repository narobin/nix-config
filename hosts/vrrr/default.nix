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
    renderDevice = "/dev/dri/by-path/pci-0000:01:00.0-render";
  };

  ddns = {
    enable = false;
    domain = "vrrr.narobin.com";
  };

  jellyfin = {
    enable = true;
  };

  networking.hostName = "vrrr";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.05";
}
