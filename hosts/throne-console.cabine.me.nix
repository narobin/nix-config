{ pkgs, ... }:
{
  imports = [
    ../modules/darwin/packages.nix
    ../modules/darwin/system.nix
    ../modules/darwin/brew.nix
    ../modules/shared/nix.nix
    ../users/cabine/cabine.nix
  ];

  networking.hostName = "throne-console.cabine.me";
  networking.localHostName = "throne-console";
  networking.computerName = "Throne Console";
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
}
