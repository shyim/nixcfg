{ config
, pkgs
, lib
, ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  home.shellAliases = {
    nano = "nvim";
    vi = "nvim";
    vim = "nvim";
  };
}
