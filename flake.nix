{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  outputs = { self, nixpkgs }: {
    nixosConfigurations.server01 = {
      modules = [
        ./services/ddclient.nix
      ]
    }
  }
}
