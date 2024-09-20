{ config
, pkgs
, lib
, flake
, ...
}: {
  imports = [
    ./programs
    ./packages.nix
    ./files.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home.username = "shyim";
  home.homeDirectory = "${
    if pkgs.stdenv.hostPlatform.isDarwin
    then "/Users/shyim"
    else "/home/shyim"
  }";
  home.stateVersion = "23.05";

  manual.manpages.enable = false;
  programs.man.enable = false;
}
