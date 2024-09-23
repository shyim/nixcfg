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
  php = pkgs.php83.buildEnv {
    extensions = { enabled, all }: enabled ++ [ all.xdebug ];
    extraConfig = ''
      memory_limit=512M
    '';
  };
in
{
  home.packages = with pkgs; [
    age
    fd
    flake.inputs.froshpkgs.packages.${system}.shopware-cli
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
    go_1_23
    php
    php.packages.composer
    git-credential-manager
    awscli2
    k9s
    k6
    watchexec
    symfony-cli
  ];

  programs.home-manager.enable = true;
}
