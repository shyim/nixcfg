{ config
, pkgs
, lib
, ...
}:
let
  _1passwordPlugins = {
    "glab" = pkgs.glab;
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

  programs.nushell = {
    enable = true;
    configFile.text = ''
      $env.config = {
        show_banner: false
      }

      alias nix-shell = nix-shell --run nu

      $env.PATH = (
        $env.PATH |
        split row (char esep) |
        prepend '/run/current-system/sw/bin' |
        prepend '/Users/shyim/.nix-profile/bin' |
        prepend '/etc/profiles/per-user/shyim/bin' |
        prepend '/nix/var/nix/profiles/default/bin' |
        append '/Users/shyim/go/bin' |
        append '/usr/local/bin'
      )

      def kswitch [name: string] {
        kubectl config set-context --current $"--namespace=($name)"
      }
    '';
    environmentVariables = {
      OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES";
      BUILDKIT_PROGRESS = "plain";
    };
  };

  programs.fish = {
    enable = true;
    loginShellInit = ''
      export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
      export BUILDKIT_PROGRESS=plain
      set fish_greeting

      function kn-switch
        kubectl config set-context --current --namespace=$argv
      end

      function kc-switch
        kubectl config use-context $argv
      end

      function awsp
        set -gx AWS_PROFILE (aws configure list-profiles | ${pkgs.fzf}/bin/fzf -1)
        echo "switched to profile: $AWS_PROFILE"
      end

      alias sudo="sudo --preserve-env=TERMINFO"

      ${lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
      fish_add_path /run/current-system/sw/bin
      ''}

      fish_add_path $HOME/.npm-packages/bin/
      fish_add_path $HOME/go/bin
    '';
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      workspaces = true;
      update_check = false;
    };
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.lsd.enable = true;
  programs.lsd.enableAliases = true;
}
