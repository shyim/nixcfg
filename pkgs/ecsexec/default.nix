{
  pkgs,
  writeShellScriptBin,
  ...
}: writeShellScriptBin "ecsexec" ''
            export PATH=$PATH:${pkgs.ssm-session-manager-plugin}/bin
            export AWS_REGION=eu-central-1

            if [[ "$AWS_SESSION_TOKEN" == "" ]]; then
              echo "Missing AWS Secrets in ENV"
              exit 1
            fi

            if [ "$1" = "" ]
              then
                echo "missing version"
                exit 1
              fi
              if [ "$2" = "fpm" ]
              then
                containerName=fpm
                serviceName=shopware
              elif [ "$2" = "nginx" ]
              then
                containerName=nginx
                serviceName=shopware
              elif [ "$2" = "kraftwork" ]
              then
                containerName=kraftwork
                serviceName=kraftwork
              else
                echo "invalid target - kraftwork or fpm"
                exit 1
              fi
              taskID=$(${pkgs.awscli2}/bin/aws ecs list-tasks --cluster shopware-application --service-name $serviceName-$1 | ${pkgs.jq}/bin/jq '.taskArns[]' -r | cut -d'/' -f3 | ${pkgs.fzf}/bin/fzf)
              ${pkgs.awscli2}/bin/aws ecs execute-command --interactive --command /bin/bash --task $taskID --cluster shopware-application --container $containerName
          ''