{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ./git
    ./shell
    ./nvim
    ./ssh
  ];
}
