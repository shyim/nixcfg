{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ./git
    ./shell
    ./neovim
    ./gtk
  ];
}
