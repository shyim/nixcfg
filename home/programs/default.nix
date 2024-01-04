{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ./git
    ./shell
    ./helix
    ./ssh
  ];
}
