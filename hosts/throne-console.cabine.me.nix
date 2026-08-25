{ ... }:
{
  imports = [
    ../modules/darwin/system.nix
    ../modules/darwin/brew.nix
    ../modules/shared/packages.nix
    ../modules/shared/nix.nix
    ../home/cabine/default.nix
  ];

  system.primaryUser = "cabine";

  networking.hostName = "throne-console.cabine.me";
  networking.localHostName = "throne-console";
  networking.computerName = "Throne Console";
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
}
