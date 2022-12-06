{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Darwin Inputs
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin-modules.url = "github:shyim/nix-darwin-modules";
    darwin-modules.inputs.nixpkgs.follows = "nixpkgs";

    phps.url = "github:fossar/nix-phps";
    phps.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv/main";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { nixpkgs, home-manager, darwin, darwin-modules, phps, devenv, self, ... }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
      extraArgs = system: { inherit nixpkgs phps devenv; myFlakePackages = self.packages.${system}; };
    in
    {
      colmena = {
        meta = {
          nixpkgs = import nixpkgs {};
          specialArgs = extraArgs "aarch64-linux";
        };

        "shea.bunny-chickadee.ts.net" = { name, nodes, pkgs, ... }: {
          deployment.tags = [ "shea" ];
          deployment.buildOnTarget = true;

          imports = [
            ./systems/shea
          ];
        };
      };

      darwinConfigurations = {
        umbreon = darwin.lib.darwinSystem {
          specialArgs = extraArgs "aarch64-darwin";
          system = "aarch64-darwin";
          modules = [
            ./systems/umbreon
            home-manager.darwinModules.default
            darwin-modules.darwinModules.default
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.shyim = import ./home;
            }
          ];
        };
      };

      devShells = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [ nixpkgs-fmt colmena git-crypt ];
          };
        }
      );

      packages = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          awsume = pkgs.callPackage ./pkgs/awsume { };
          elasticsearch8 = pkgs.callPackage ./pkgs/elasticsearch8 { };
          openjdk = pkgs.callPackage ./pkgs/openjdk { };
          opensearch = pkgs.callPackage ./pkgs/opensearch { };
          screego = pkgs.callPackage ./pkgs/screego { };
          wakapi = pkgs.callPackage ./pkgs/wakapi { };
        }
      );
    };
}
