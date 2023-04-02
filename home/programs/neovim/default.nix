{ config
, pkgs
, lib
, ...
}:
{
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      nvim-tree-lua
      go-nvim
      copilot-vim
    ];
    extraConfig = ''
      set number relativenumber
    '';
  };
}