{ config, pkgs, lib, devenv, home-manager, ... }:

{
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
    cachix
    devenv.packages.${system}.devenv
  ];

  programs.home-manager.enable = true;
}
