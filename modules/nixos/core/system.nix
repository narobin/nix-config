{ ... }:
{
  system.autoUpgrade = {
    enable = true;
    flake = "github:narobin/nix-config";
    dates = "04:05";
    upgrade = false;
    allowReboot = true;
    rebootWindow = {
      lower = "03:00";
      upper = "05:00";
    };
  };

  # systemd.timers.nixos-upgrade = {
  #   timerConfig = {
  #     OnCalendar = "04:00";
  #     WakeSystem = true;
  #     AccuracySec = "1min";
  #   };
  # };
}
