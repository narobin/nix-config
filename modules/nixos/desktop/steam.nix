{ config, lib, pkgs, ... }: {
  config = lib.mkIf config.mySystem.enableGui {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = false;
      localNetworkGameTransfers.openFirewall = true;
    };

    environment.systemPackages = with pkgs; [
      (pkgs.steam.override {
        extraPkgs = p: [ p.libgdiplus p.openssl p.curl ];
      })
    ];
  };
}
