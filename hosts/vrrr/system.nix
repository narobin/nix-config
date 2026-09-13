{ config, pkgs, ... }: {
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-63-6.18.49"
  ];

  boot.kernelModules = [ "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  powerManagement.enable = true;

  networking.interfaces.wlp3s0.wakeOnLan.enable = true;

  services.logind.settings.Login = {
    IdleAction="suspend"
    IdleActionSec="10min"
  };

  # NVIDIA
  # TODO: move to module with option
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    powerManagement.enable = true;
    nvidiaSettings = true;
    branch = "legacy_580";
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };
}
