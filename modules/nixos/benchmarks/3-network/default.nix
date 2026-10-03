{ ... }:
{
  imports = [
    ./3_1-host.nix
    ./3_2-host-router.nix
    ./3_3-tcp-wrappers.nix
    ./3_4-uncommon-protocols.nix
    ./3_5-firewall.nix
  ];
}
