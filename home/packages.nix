{ config
, pkgs
, lib
, devenv
, home-manager
, shopware-cli
, ...
}: {
  home.packages = with pkgs; [
    nixpkgs-fmt
    git
    htop
    jq
    tree
    tmux
    wget
    git-crypt
    fd
    bash
    gh
    asciinema
    ripgrep
    bat
    devenv.packages.${system}.devenv
    shopware-cli.packages.${system}.shopware-cli
    shopware-cli.packages.${system}.dart-sass-embedded
    fastly
    rclone
  ];

  programs.home-manager.enable = true;
}
