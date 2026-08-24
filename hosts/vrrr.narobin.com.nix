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
    ../modules/users/nazh.nix
  ];

  mySystem.enableGui = true;

  networking.hostName = "vrrr.narobin.com";
  networking.computerName = "VRRR";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = 6;
}
