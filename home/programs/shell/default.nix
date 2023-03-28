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
      exec op plugin run -- ${name} "$@"
    '')
    (builtins.attrNames _1passwordPlugins);

  programs.starship = {
    enable = true;
    settings = {
      container = {
        disabled = true;
      };
      username = {
        show_always = true;
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      cat = "bat";
    };
    loginShellInit = ''
      export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
      export EDITOR=nvim
      set fish_greeting

      ${lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''}
        fish_add_path /run/current-system/sw/bin
      ''}

      fish_add_path $HOME/.npm-packages/bin/

      function ecsexec
          if not set -q argv[1]
            echo "missing version"
            return 1
          end

          if not set -q argv[2]
            set containerName fpm
            set serviceName shopware
          else
              switch $argv[2];
                  case "fpm";
                      set containerName fpm
                      set serviceName shopware
                  case "nginx"
                      set containerName nginx
                      set serviceName shopware
                  case "kraftwork";
                      set containerName kraftwork
                      set serviceName kraftwork
              end
          end

          set taskID (aws ecs list-tasks --cluster shopware-application --service-name $serviceName-$argv[1] | jq '.taskArns[]' -r | cut -d'/' -f3 | fzf)
          aws ecs execute-command --interactive --command /bin/bash --task $taskID --cluster shopware-application --container $containerName
      end

      alias jl="jira sprint list --current -q 'assignee = currentUser()'"

      function j
          set issue $argv[1]
          set -e argv[1]

          for p in $argv
              switch $p;
                  case "me";
                      jira issue edit $issue --no-input --assignee (jira me) --custom "team=CT Core"
                      echo "Assigned it to me"
                  case "sp1";
                      jira issue edit $issue --no-input --custom "story-points=1"
                      echo "Set story-points to 1"
                  case "sp2";
                      jira issue edit $issue --no-input --custom "story-points=2"
                      echo "Set story-points to 2"
                  case "sp3";
                      jira issue edit $issue --no-input --custom "story-points=3"
                      echo "Set story-points to 3"
                  case "sp5";
                      jira issue edit $issue --no-input --custom "story-points=5"
                      echo "Set story-points to 5"
                  case "sp8";
                      jira issue edit $issue --no-input --custom "story-points=8"
                      echo "Set story-points to 8"
                  case "sprint";
                      jira issue edit $issue --no-input --custom=sprint=$currentSprint
                      echo "Moved to current sprint"
                  case "open";
                      jira issue move $issue "Open"
                      echo "Moved it to Open"
                  case "pending";
                      jira issue move $issue "Pending"
                      echo "Moved it to Pending"
                  case "in-progress";
                      jira issue move $issue "In Progress"
                      echo "Moved it to In Progress"
                  case "in-review";
                      jira issue move $issue "In Review"
                      echo "Moved it to In Review"
                  case "resolve";
                      jira issue move $issue "Resolve"
                      echo "Moved it to Resolve"
              end
          end
      end

      complete -c q -s g -l git -d "Use git assist"
      complete -c q -s h -l gh -d "Use GitHub CLI assist"

      function q
          argparse -si --name q g/git h/gh -- $argv

          # make sure we're not running an old command if copilot fails later
          rm -rf /tmp/copilot_output

          set query "$argv"
          if not test "$query"
              # prompt user for input if no query is provided
              read --prompt "set_color --bold 6b75ff; echo -n \" What do you want to do? \"; set_color normal; set_color brblack; echo -n \u203a \"\"; set_color normal;" query
          end

          if not test "$query"
              # no query provided, exit
              return 1
          end

          set subcmd what-the-shell
          if test "$_flag_g"
              set subcmd git-assist
          end
          if test "$_flag_h"
              set subcmd gh-assist
          end

          # run copilot
          github-copilot-cli $subcmd --shellout /tmp/copilot_output "On Fish Shell: $query"

          if test "$status" -ne 0
              # copilot failed, exit
              return 1
          end

          # read copilot output
          set cmd (cat /tmp/copilot_output)

          if not test "$cmd"
              # no command from copilot, exit
              return 1
          end

          # execute command
          commandline $cmd
          commandline -f execute
      end
    '';
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.bat.enable = true;

  programs.lsd.enable = true;
  programs.lsd.enableAliases = true;
}
