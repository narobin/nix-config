{ ... }:
{
  system.autoUpgrade = {
    enable = true;
    flake = "github:narobin/nix-config";
    upgrade = false;
    allowReboot = true;
    rebootWindow = {
      lower = "03:00";
      upper = "05:00";
    }
  }
}
