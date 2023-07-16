{ config
, pkgs
, lib
, ...
}: {
  services.openssh.enable = true;

  # Nginx
  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
  };
  security.acme = {
    acceptTerms = true;
    email = "acme@shyim.de";
  };

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
