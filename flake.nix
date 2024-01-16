{
  nixConfig = {
    extra-trusted-public-keys = "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=";
    extra-substituters = "https://cache.garnix.io";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";

    # Darwin Inputs
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv.url = "github:cachix/devenv/main";
    devenv.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.inputs.nixpkgs-stable.follows = "nixpkgs";

    mac-app-util.url = "github:hraban/mac-app-util";
    jetbrains = {
      url = "github:shyim/jetbrains-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    froshpkgs = {
      url = "github:FriendsOfShopware/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { nixpkgs
    , home-manager
    , darwin
    , devenv
    , self
    , sops-nix
    , ...
    }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      extraArgs = {
        inherit sops-nix;
        flake = self;
      };
      nixpkgsConfig = {
        config = { allowUnfree = true; };
      };
    in
    {
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
          ecsexec = pkgs.callPackage ./pkgs/ecsexec { };
          bun = pkgs.callPackage ./pkgs/bun { };
          #bun = pkgs.bun;
          devenv = devenv.packages.${system}.devenv;

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

