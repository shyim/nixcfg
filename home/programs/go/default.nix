{ pkgs, flake, ... }: {
  programs.go = {
    enable = true;
    package = flake.inputs.nixpkgs-staging.legacyPackages.${pkgs.system}.go_1_21;
  };
}
