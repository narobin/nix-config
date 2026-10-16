{ ... }:
{
  imports = [
    ../../modules/nixos
    ../../modules/shared
    ../../home/noah
    ./hardware.nix
    ./system.nix
  ];

  mySystem = {
    enableGui = true;
    enableWireless = true;
    renderDevice = "/dev/dri/by-path/pci-0000:01:00.0-render";
    hardwareAcceleration.enable = true;
  };

  jellyfin = {
    enable = true;
    configureTailscale = true;
  };

  services.cloudflared.enable = true;

  kanidm.server.enable = true;

  services.tailscale = {
    enable = true;
    # serve.enable = true;
    butler.enable = true;
  };

  services.immich = {
    enable = true;
    configureKanidm = true;
    configureTailscale = true;
  };

  services.forgejo = {
    enable = true;
    configureKanidm = true;
    configureTailscale = true;
  };

  services.vaultwarden = {
    enable = true;
    configureKanidm = true;
    configureTailscale = true;
  };

  services.blocky.enable = true;

  # services.sunshine.enable = true;

  networking.hostName = "vrrr";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.05";
}
