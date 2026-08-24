{ pkgs, ... }:
{
  imports = [
    ../modules/darwin/system.nix
    ../modules/darwin/brew.nix
    ../modules/shared/packages.nix
    ../modules/shared/nix.nix
    ../modules/users/nazh.nix
  ];

  networking.hostName = "codifier.narobin.com";
  networking.localHostName = "codifier";
  networking.computerName = "Codifier";
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
}
