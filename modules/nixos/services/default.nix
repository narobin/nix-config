{ ... }:
{
  imports = [
    ./jellyfin.nix
    ./kanidm.nix
    ./tailscale.nix
    ./immich.nix
    ./forge.nix
    ./vaultwarden.nix
    ./remote-desktop.nix
    ./blocky.nix
    ./miniflux.nix
    ./smart-home
  ];
}
