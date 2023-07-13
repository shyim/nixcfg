{ flake
, pkgs
, lib
, flake
, ...
}: {
    nix.distributedBuilds = false;
    nix.buildMachines = [ ];

    environment.systemPackages = with pkgs; [
        flake.inputs.devenv.packages.${system}.devenv
        cachix
    ];
}