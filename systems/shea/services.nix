{ config
, pkgs
, lib
, ...
}: {
  services.openssh.enable = true;

  # Caddy
  services.caddy.enable = true;

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
