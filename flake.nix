{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    colmena.url = "github:zhaofengli/colmena";
  };
  outputs =
    {
      nixpkgs,
      colmena,
      sops-nix,
      self,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      extraArgs = {
        flake = self;
      };
      nixpkgsConfig = {
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      # Add formatter for nix files
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      colmenaHive = colmena.lib.makeHive self.outputs.colmena;
      colmena = {
        meta = {
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
          };
        };
        "snorlax" = {
          deployment.targetHost = "snorlax.shyim.de";
          deployment.buildOnTarget = true;
          imports = [
            ./systems/nas
            sops-nix.nixosModules.sops
          ];
        };

        "shea" = {
          deployment.targetHost = "shea.shyim.de";
          deployment.buildOnTarget = true;
          imports = [
            ./systems/shea
            sops-nix.nixosModules.sops
          ];
        };
      };
    };
}
