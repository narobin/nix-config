{ ... }:
{
  imports = [
    ../modules/darwin
    ../modules/shared
    ../home/noah
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
