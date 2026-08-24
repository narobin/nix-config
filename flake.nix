{
  description = "nix config for Nazh and Cabine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follow = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      sops-nix
    }@inputs:
    let
      mkDarwinHost =
        module:
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };

              home-manager.sharedModules = [
                ({ pkgs, ... }: {
                  home.stateVersion = "26.05";
                  programs.home-manager.enable = true;
                })
              ];
            }
            sops-nix.darwinModules.sops
            module
          ];
        };
      mkHost =
        module:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };

              home-manager.sharedModules = [
                ({ pkgs, ... }: {
                  home.stateVersion = "26.05";
                  programs.home-manager.enable = true;
                })
              ];
            }
            sops-nix.nixosModules.sops
            module
          ];
        };
    in
    {
      nixosConfigurations = {
        "servitor.narobin.com" = mkHost ./hosts/servitor.narobin.com.nix;
        "vrrr.narobin.com" = mkHost ./hosts/vrrr.narobin.com.nix;
      };

      darwinConfigurations = {
        "throne-console.cabine.me" = mkDarwinHost ./hosts/throne-console.cabine.me.nix;
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
            sops
            age
          ];

          shellHook = ''
            export NIX_PATH="nixpkgs=${nixpkgs}"
          '';
        };
    };
}
