{ config
, pkgs
, lib
, ...
}: {
  services.openssh.enable = true;

  sops.secrets.caddy_env = {
    restartUnits = [ "caddy.service" ];
  };

  # Caddy
  services.caddy.enable = true;
  services.caddy.globalConfig = ''
    admin off
  '';
  systemd.services.caddy.serviceConfig.EnvironmentFile = lib.mkForce config.sops.secrets.caddy_env.path;

  # MySQL
  services.mysql.enable = true;
  services.mysql.settings = {
    "mysqld" = {
      "skip-networking" = true;
    };
  };
  services.mysql.package = pkgs.mysql80;
  services.mysql.initialDatabases = [{ name = "wakapi"; }];
  services.mysql.ensureUsers = [
    {
      name = "wakapi";
      ensurePermissions = {
        "wakapi.*" = "ALL PRIVILEGES";
      };
    }
  ];
}
