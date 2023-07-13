{ flake
, pkgs
, lib
, ...
}: {
    nix.distributedBuilds = lib.mkForce false;
    nix.buildMachines = lib.mkForce [ ];

    environment.systemPackages = with pkgs; [
        flake.inputs.devenv.packages.${system}.devenv
        cachix
    ];
}