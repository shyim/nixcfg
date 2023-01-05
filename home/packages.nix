{ config
, pkgs
, lib
, devenv
, home-manager
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
    fastly
  ];

  programs.home-manager.enable = true;
}
