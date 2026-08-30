{ ... }:
{
  imports = [
    ../modules/shared/settings.nix
    ../modules/shared/nix.nix
    ../modules/darwin/system.nix
    ../modules/darwin/brew.nix
    ../modules/shared/packages.nix
    ../home/noah/default.nix
  ];

  system.primaryUser = "noah";

  mySystem.enableGui = true;

  homebrew.casks = [
    "citrix-workspace"
  ];

  networking.hostName = "codifier.narobin.com";
  networking.localHostName = "codifier";
  networking.computerName = "Codifier";
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 6;
}
