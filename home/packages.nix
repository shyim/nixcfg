{ pkgs
, flake
, ...
}:

let
  nixSha = pkgs.writeShellScriptBin "nix-sha" ''
    nix hash to-sri sha256:$(nix-prefetch-url $1)
  '';
  php = pkgs.php.buildEnv {
    extensions = ({ enabled, all }: enabled ++ (with all; [
      redis
    ]));
    extraConfig = ''
      memory_limit=512M
    '';
  };
in
{
  home.packages = with pkgs; [
    asciinema
    fd
    curl
    php
    flake.inputs.froshpkgs.packages.${system}.shopware-cli
    devenv
    gh
    htop
    jq
    nixSha
    go
    golangci-lint
    ripgrep
    nodejs_22
    corepack_22
    sops
    hyperfine
    tmux
    kubectl
    kubectl-neat
    nixd
    kubernetes-helm
    awscli2
    k6
    watchexec
    tree
    syft
  ];

  programs.home-manager.enable = true;
}
