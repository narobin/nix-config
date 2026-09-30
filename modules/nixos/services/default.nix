{ ... }:
{
  imports = [
    ./jellyfin.nix
    ./kanidm.nix
    ./tailscale.nix
    ./immich.nix
    ./forge.nix
  ];
}
