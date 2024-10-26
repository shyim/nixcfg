{ config
, pkgs
, lib
, flake
, ...
}:

let
  nixSha = pkgs.writeShellScriptBin "nix-sha" ''
    nix hash to-sri sha256:$(nix-prefetch-url $1)
  '';
in
{
  home.packages = with pkgs; [
    fd
    flake.inputs.froshpkgs.packages.${system}.shopware-cli
    devenv
    gh
    htop
    jq
    nixSha
    ripgrep
    nodejs_22
    corepack_22
    sops
    tmux
    kubectl
    kubectl-neat
    nixd
    kubernetes-helm
    awscli2
    k6
    watchexec
  ];

  programs.home-manager.enable = true;
}
