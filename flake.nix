{
  description = "nix config for Nazh and Cabine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { nixpkgs }: {
    nixosConfigurations."servitor.narobin.com" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./hosts/servitor.narobin.com.nix ];
    };

    nixosConfigurations."vrrr.narobin.com" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./hosts/vrrr.narobin.com.nix ];
    };

    # Define development environment for this project
    devShells."aarch64-darwin".default =
      let
        pkgs = nixpkgs.legacyPackages."aarch64-darwin";
      in
      pkgs.mkShell {
        packages = with pkgs; [
          nil
          nixd
          nixfmt-rfc-style
          git
        ];

        shellHook = ''
          export NIX_PATH="nixpkgs=${nixpkgs}"
        '';
      };
  };
}
