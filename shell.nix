{
  description = "nix development shell with LSP servers"

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  
  outputs = { self, nixpkgs };

  let
    system = builtins.currentSystem;
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        nil
        nixd
        nixfmt-rfc-style
      ];

      shellHook = ''
        export NIX_PATH="nixpkgs=${nixpkgs}"
      ''
    }
  }

}
