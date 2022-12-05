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
  outputs = { nixpkgs, home-manager, darwin, darwin-modules, phps, devenv, ... }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
      extraArgs = { inherit nixpkgs phps devenv; };
    in
    {
      colmena = {
        meta = {
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
          };
        };

        "helia.shyim.de" = { name, nodes, pkgs, ... }: {
          deployment.tags = [ "helia" ];

          imports = [
            ./systems/helia
          ];
        };

        "shea.shyim.de" = { name, nodes, pkgs, ... }: {
          deployment.tags = [ "shea" ];
          deployment.buildOnTarget = true;

          imports = [
            ./systems/shea
          ];
        };
      };

      darwinConfigurations = {
        umbreon = darwin.lib.darwinSystem {
          specialArgs = extraArgs;
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

      devShell = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in pkgs.mkShell {
          buildInputs = with pkgs; [ nixpkgs-fmt colmena git-crypt ];
        });
    };
}
