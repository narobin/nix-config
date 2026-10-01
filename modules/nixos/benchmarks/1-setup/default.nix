{ ... }:
{
  imports = [
    ./1_1-filesystem.nix
    ./1_2-updates.nix
    ./1_3-integrity.nix
    ./1_4-secure-boot.nix
    ./1_5-process-hardening.nix
    ./1_6-access-control.nix
    ./1_7-warning-banners.nix
  ];
}
