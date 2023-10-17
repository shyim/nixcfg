{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ./git
    ./shell
    ./neovim
    ./go
    ./ssh
  ];
}
