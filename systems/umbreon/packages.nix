{ pkgs, devenv, phps, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
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
    minio
    redis
    mysql80
    git
    htop
    jq
    tree
    tmux
    wget
    git-crypt
    nodejs-16_x
    platformsh
    fd
    hcloud
    rbw
    rnix-lsp
    yarn
    mailhog
    awscli2
    siege
    bash
    cloudflared
    ssm-session-manager-plugin
    awsume
    go-jira
    colima
    platformsh
    gh
    asciinema
    ripgrep
    htop
    bat
    symfony-cli
    qemu
    cachix
    devenv.packages.aarch64-darwin.devenv
  ];
}
