{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Darwin Inputs
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin-modules.url = "github:shyim/nix-darwin-modules";
    darwin-modules.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv/main";
    devenv.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixd.url = "github:nix-community/nixd";
  };
  outputs =
    { nixpkgs
    , home-manager
    , darwin
    , darwin-modules
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
    in
    {
      colmena = {
        meta = {
          nixpkgs = import nixpkgs { system = "aarch64-linux"; };
          specialArgs = extraArgs;
        };

        "shea.bunny-chickadee.ts.net" =
          { name
          , nodes
          , pkgs
          , ...
          }: {
            deployment.tags = [ "shea" ];
            deployment.buildOnTarget = true;

            imports = [
              sops-nix.nixosModules.sops
              ./systems/shea
            ];
          };
      };

      darwinConfigurations = {
        umbreon = darwin.lib.darwinSystem {
          specialArgs = extraArgs // { remapKeys = false; };
          system = "aarch64-darwin";
          modules = [
            ./systems/generic-mac
            home-manager.darwinModules.default
            darwin-modules.darwinModules.default
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = extraArgs;
              home-manager.users.shyim = import ./home;
            }
          ];
        };
        espeon = darwin.lib.darwinSystem {
          specialArgs = extraArgs // { remapKeys = true; };
          system = "aarch64-darwin";
          modules = [
            ./systems/generic-mac
            home-manager.darwinModules.default
            darwin-modules.darwinModules.default
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = extraArgs;
              home-manager.users.shyim = import ./home;
            }
          ];
        };
        bob = darwin.lib.darwinSystem {
          specialArgs = extraArgs // { remapKeys = false; };
          system = "aarch64-darwin";
          modules = [
            ./systems/generic-mac
            ./systems/bob
          ];
        };
      };

      nixosConfigurations = {
        melody = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./systems/melody
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = extraArgs;
              home-manager.users.shyim = import ./home;
            }
          ];
        };
      };

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [ colmena ];
          };
        }
      );

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
          screego = pkgs.callPackage ./pkgs/screego { };
          wakapi = pkgs.callPackage ./pkgs/wakapi { };
          yuzu-room = pkgs.callPackage ./pkgs/yuzu-room { };
          ecsexec = pkgs.callPackage ./pkgs/ecsexec { };
          cloudreve = pkgs.callPackage ./pkgs/cloudreve { };

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
