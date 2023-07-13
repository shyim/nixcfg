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
    ./ssh.nix
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
    secrets.nix_ssh = {
      path = "${config.home.homeDirectory}/.nix-ssh-key";
      format = "yaml";
      mode = "0600";
    };
  };

  home.sessionVariables.NIX_USER_CONF_FILES = "${config.home.homeDirectory}/.config/nix/nix.conf:${config.home.homeDirectory}/.nix-access-token";
  systemd.user.sessionVariables.NIX_USER_CONF_FILES = "${config.home.homeDirectory}/.config/nix/nix.conf:${config.home.homeDirectory}/.nix-access-token";
}
