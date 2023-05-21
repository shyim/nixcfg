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
    ./wsl.nix
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
    secrets.nix_secrets = {
      path = "${config.home.homeDirectory}/.nix-access-token";
      format = "yaml";
    };
  };

  home.sessionVariables.NIX_USER_CONF_FILES = "${config.home.homeDirectory}/.config/nix/nix.conf:${config.home.homeDirectory}/.nix-access-token";
  systemd.user.sessionVariables.NIX_USER_CONF_FILES = "${config.home.homeDirectory}/.config/nix/nix.conf:${config.home.homeDirectory}/.nix-access-token";

  home.sessionVariables.SSH_AUTH_SOCK = "${config.home.homeDirectory}/${if pkgs.stdenv.hostPlatform.isDarwin then "Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" else ".1password/agent.sock"}";
  systemd.user.sessionVariables.SSH_AUTH_SOCK = "${config.home.sessionVariables.SSH_AUTH_SOCK}";
}
