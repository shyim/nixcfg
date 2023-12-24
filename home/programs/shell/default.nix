{ config
, pkgs
, lib
, ...
}:
let
  _1passwordPlugins = {
    "glab" = pkgs.glab;
    "cachix" = pkgs.cachix;
    "aws" = pkgs.awscli2;
    "hcloud" = pkgs.hcloud;
  };
in
{
  home.packages = builtins.map
    (name: pkgs.writeShellScriptBin name ''
      
      export OP_PLUGIN_ALIASES_SOURCED=1
      export PATH="${_1passwordPlugins."${name}"}/bin:$PATH"
      ${if pkgs.stdenv.hostPlatform.isDarwin then
      ''
      exec op plugin run -- ${name} "$@"
      ''
      else
      ''
      exec ${name} "$@"
      ''
      }
    '')
    (builtins.attrNames _1passwordPlugins);

  programs.starship = {
    enable = true;
    settings = {
      container = {
        disabled = true;
      };
      battery = {
        disabled = true;
      };
      username = {
        show_always = true;
      };
    };
  };

  programs.fish = {
    enable = true;
    loginShellInit = ''
      export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
      export EDITOR=nvim
      set fish_greeting

      function kswitch
        kubectl config set-context --current --namespace=$argv
      end

      ${lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
      fish_add_path /run/current-system/sw/bin
      ''}

      fish_add_path $HOME/.npm-packages/bin/
    '';
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      workspaces = true;
      update_check = false;
    };
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.bat.enable = true;
  programs.zoxide.enable = true;

  programs.lsd.enable = true;
  programs.lsd.enableAliases = true;
}
