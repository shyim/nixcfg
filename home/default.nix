{ config
, pkgs
, lib
, devenv
, home-manager
, flake
, sops-nix
, ...
}: {
  imports = [
    flake.inputs.sops-nix.homeManagerModule

    ./programs
    ./packages.nix
    ./files.nix
    ./wsl.nix
    ./linux.nix
  ];

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
