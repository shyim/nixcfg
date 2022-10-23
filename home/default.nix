{ config, pkgs, lib, ... }:

{
  imports = [
    ./programs
  ];

  home.stateVersion = "22.11";
}
