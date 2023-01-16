{ config
, pkgs
, lib
, devenv
, home-manager
, ...
}: {
  imports = [
    ./programs
    ./packages.nix
  ];

  home.username = "shyim";
  home.homeDirectory = "${
    if pkgs.stdenv.hostPlatform.isDarwin
    then "/Users/shyim"
    else "/home/shyim"
  }";
  home.stateVersion = "22.11";

  manual.manpages.enable = false;
  programs.man.enable = false;
}
