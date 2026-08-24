{ pkgs, ... }:
{
  imports = [
    ../modules/nixos/boot.nix
    ../modules/nixos/locale.nix
    ../modules/nixos/networking.nix
    ../modules/nixos/packages.nix
    ../modules/nixos/security.nix
    ../modules/shared/packages.nix
    ../modules/shared/nix.nix
    ../modules/shared/settings.nix
    ../modules/users/noah.nix
    ../modules/users/cabine.nix
  ];

  mySystem.enableGui = false;

  networking.hostName = "servitor.narobin.com";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = 6;
}
