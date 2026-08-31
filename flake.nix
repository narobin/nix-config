{
  description = "nix config for Nazh and Cabine";

  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    nixpkgs-nixos.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    home-manager-nixos = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-nixos";
    };
    home-manager-darwin = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      #inputs.nixpkgs.follow = "nixpkgs-nixos";
    };
  };

  outputs =
    {
      self,
      determinate,
      nixpkgs-nixos,
      nixpkgs-darwin,
      nix-darwin,
      home-manager-nixos,
      home-manager-darwin,
      sops-nix,
    }@inputs:
    let
      mkDarwinHost =
        module:
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            determinate.darwinModules.default
            home-manager-darwin.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };

              home-manager.sharedModules = [
                ({ ... }: {
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
        nixpkgs-nixos.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            determinate.nixosModules.default
            home-manager-nixos.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };

              home-manager.sharedModules = [
                ({ ... }: {
                  home.stateVersion = "26.05";
                  programs.home-manager.enable = true;
                })
              ];
            }
            ({ ... }: {
              determinateNix.enable = true;
            })
            sops-nix.nixosModules.sops
            module
          ];
        };
    in
    {
      nixosConfigurations = {
        servitor = mkHost ./hosts/servitor;
        vrrr = mkHost ./hosts/vrrr;
      };

      darwinConfigurations = {
        throne-console = mkDarwinHost ./hosts/throne-console;
        codifier = mkDarwinHost ./hosts/codifier;
      };

      # Define development environment for this project
      devShells."aarch64-darwin".default =
        let
          pkgs = nixpkgs-darwin.legacyPackages."aarch64-darwin";
        in
        pkgs.mkShell {
          packages = with pkgs; [
            nil
            nixd
            nixfmt
            git
            sops
            age
            fish
          ];

          env = {
            NIX_PATH = "nixpkgs=${nixpkgs-darwin}";
          };

          shellHook = "exec fish";
        };
    };
}
