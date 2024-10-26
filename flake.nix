{
  nixConfig = {
    extra-trusted-public-keys = "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=";
    extra-substituters = "https://cache.garnix.io";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Darwin Inputs
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    froshpkgs = {
      url = "github:FriendsOfShopware/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { nixpkgs
    , home-manager
    , darwin
    , sops-nix
    , self
    , ...
    }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      extraArgs = {
        flake = self;
      };
      nixpkgsConfig = {
        config = { allowUnfree = true; };
      };
    in
    {
      colmena = {
        meta = {
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
          };
        };
        "snorlax" = {
          deployment.targetHost = "192.168.31.92";
          deployment.buildOnTarget = true;
          imports = [
            ./systems/nas
            sops-nix.nixosModules.sops
          ];
        };
      };

      darwinConfigurations = {
        deoxys = darwin.lib.darwinSystem {
          specialArgs = extraArgs;
          system = "aarch64-darwin";
          modules = [
            ./systems/generic-mac
            home-manager.darwinModules.default
            {
              nixpkgs = nixpkgsConfig;
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = extraArgs;
              home-manager.users.shyim = import ./home;
            }
          ];
        };
      };

      formatter = forAllSystems (
        system:
        nixpkgs.legacyPackages.${system}.nixpkgs-fmt
      );

      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          homeConfigurations.shyim = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            modules = [
              ./home
            ];

            extraSpecialArgs = extraArgs;
          };
        }
      );
    };
}
