{ config
, pkgs
, lib
, devenv
, home-manager
, sops-nix
, ...
}: {
  imports = [
    ./programs
    ./packages.nix
    ./files.nix
    sops-nix.homeManagerModule
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

  sops = {
    age.keyFile = "${
    if pkgs.stdenv.hostPlatform.isDarwin
    then "/Users/shyim/Library/Application Support/sops/age/keys.txt"
    else "/home/shyim/.config/sops/age/keys.txt"
  }";
    defaultSopsFile = ./sops/default.yaml;
    secrets.go-github-to-jira = {
      path = "${config.home.homeDirectory}/.go-github-to-jira.yaml"; 
      format = "yaml";
    };
  };

  # home.sessionVariables.SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
  # systemd.user.sessionVariables.SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
}
