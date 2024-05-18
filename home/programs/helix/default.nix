{ config
, pkgs
, lib
, ...
}:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
  };

  home.shellAliases = {
    nano = "hx";
    vi = "hx";
    vim = "hx";
  };
}
