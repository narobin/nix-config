{ config, pkgs, ... }: {
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-63-6.18.49"
  ];

  boot.kernelModules = [ "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  # NVIDIA
  # TODO: move to module with option
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
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

