{ ... }:
{
  imports = [
    ./boot.nix
    ./locale.nix
    ./networking.nix
    ./packages.nix
    # ./sops.nix
    ./ssh.nix
  ];
}
