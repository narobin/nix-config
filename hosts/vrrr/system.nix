{ pkgs, ... }: {
  powerManagement.enable = true;

  networking.interfaces.wlp3s0.wakeOnLan.enable = true;

  services.logind.settings.Login = {
    IdleAction = "suspend";
    IdleActionSec = "10min";
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

  boot.extraModprobeConfig = ''
    options nvidia_drm modeset=1 fbdev=0
    options nvidia_modeset vblank_sem_control=0
  '';

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };
}
