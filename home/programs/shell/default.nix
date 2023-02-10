{ config
, pkgs
, lib
, ...
}: {
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
      nano = "nvim";
      vim = "nvim";
      vi = "nvim";
      cat = "bat";
    };
    loginShellInit = ''
      export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
      export EDITOR=nvim
      set fish_greeting

      export OP_PLUGIN_ALIASES_SOURCED=1
      alias glab="op plugin run -- glab"
      alias cachix="op plugin run -- cachix"
      alias aws="op plugin run -- aws"

      fish_add_path /run/current-system/sw/bin

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
    '';
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.bat.enable = true;

  programs.lsd.enable = true;
  programs.lsd.enableAliases = true;
}
