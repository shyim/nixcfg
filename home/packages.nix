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
    (neovim.override {
      vimAlias = true;
      configure = {
        packages.myPlugins = with vimPlugins; {
          start = [ vim-lastplace vim-nix ];
          opt = [ ];
        };
        customRC = ''
          " your custom vimrc
          set nocompatible
          set backspace=indent,eol,start
          set mouse=
          " ...
        '';
      };
    })
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
    glab
    cachix
    devenv.packages.${system}.devenv
    shopware-cli.packages.${system}.shopware-cli
    shopware-cli.packages.${system}.dart-sass-embedded
    fastly
    awscli2
    rclone
  ];

  programs.home-manager.enable = true;
}
