{ config, pkgs, ... }:

{
  users.defaultUserShell = pkgs.fish;

  environment = {
    variables = {
      EDITOR = "nvim";
    };

    shellAliases = {
      nano = "nvim";
      vi = "nvim";
      vim = "nvim";
    };
  };

  programs.fish = {
    enable = true;
  };
}
