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
    ./files.nix
    ./secrets
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

  home.sessionVariables.SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
  systemd.user.sessionVariables.SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
}
