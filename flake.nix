{
  description = "nix config for Nazh and Cabine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      determinate,
      nixpkgs,
      nix-darwin,
      home-manager,
      sops-nix,
      flake-utils,
    }@inputs:
    let
      mkDarwinHost =
        module:
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs; };
          modules = [
            determinate.darwinModules.default
            home-manager.darwinModules.home-manager
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
            ({ ... }: {
              determinateNix.enable = true;
            })
            module
          ];
        };
      mkHost =
        module:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            determinate.nixosModules.default
            home-manager.nixosModules.home-manager
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
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nil
            nixd
            nixfmt
            git
            sops
            age
            fish
          ];
        };
      }
    );
}
