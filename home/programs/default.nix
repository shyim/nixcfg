{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ./git
    ./shell
    ./neovim
    ./pipewire
    ./gtk
    ./go
    ./ssh
  ];
}
