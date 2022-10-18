{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.docker-compose;
  jsonValue = with types;
    let
      valueType = nullOr (oneOf [
        bool
        int
        float
        str
        (lazyAttrsOf valueType)
        (listOf valueType)
      ]) // {
        description = "JSON value";
        emptyValue.value = { };
      };
    in valueType;
  composeOpts = { name, ... }:
    let
      composeOpts = cfg.${name};
    in
    {
      options = {
          config = mkOption {
            type = jsonValue;
            default = {};
        };
      };
    };
in {
  options.services.docker-compose = mkOption {
    type = types.attrsOf (types.submodule composeOpts);

    default = {};
  };


  config = mkIf (cfg != {}) {
    virtualisation.docker.enable = true;

    systemd.services = mapAttrs' (composeName: composeOpts:
      nameValuePair "compose-${composeName}" {
        description = "Starts all services for ${composeName}";
        after = [ "docker.target" ];
        wantedBy = [ "multi-user.target" ];
        environment = {
            COMPOSE_PROJECT_NAME = composeName;
        };

        serviceConfig = let
          cfgFile = pkgs.writeText "docker-compose.yml"
          (builtins.toJSON composeOpts.config);
        in {
          User = "root";
          Type = "simple";
          ExecStart = "${pkgs.docker-compose}/libexec/docker/cli-plugins/docker-compose -f ${cfgFile} up --remove-orphans";
          ExecStop = "${pkgs.docker-compose}/libexec/docker/cli-plugins/docker-compose -f ${cfgFile} stop";
          Restart = "on-failure";
        };
      }
    ) cfg;
  };
}
