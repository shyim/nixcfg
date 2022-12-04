{ config, pkgs, ... }:

{
  imports = [
    ./wakapi.nix
    ./thelounge.nix
  ];
}
