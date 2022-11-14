{ pkgs, lib, config, ... }: {
  services.redis.enable = true;
  services.redis.dataDir = null;
  services.redis.extraConfig = ''
    save ""
  '';

  services.mysql.enable = true;
  services.mysql.extraOptions = ''
    sql-require-primary-key=ON
    sql_mode="STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION"
  '';
  services.mysql.extraClientOptions = ''
    user=root
    password=root
  '';

  users.users.shyim = {
    name = "shyim";
    home = "/Users/shyim";
  };

  services.caddy.enable = true;
  services.caddy.virtualHosts."http://sw6.dev.localhost" = {
    extraConfig = ''
      root * /Users/shyim/Code/sw6/public
      php_fastcgi unix/${config.services.phpfpm.pools.php81.socket}
      encode gzip
      file_server
    '';
  };

  services.caddy.virtualHosts."http://flex.dev.localhost" = {
    extraConfig = ''
      root * /Users/shyim/Code/flex/public
      php_fastcgi unix/${config.services.phpfpm.pools.php81.socket}
      encode gzip
      file_server
    '';
  };

  services.caddy.virtualHosts."http://db.localhost" = {
    extraConfig = ''
      root * ${pkgs.adminer}
      php_fastcgi unix/${config.services.phpfpm.pools.php81.socket} {
        index adminer.php
      }
      encode gzip
    '';
  };

  services.elasticsearch.enable = true;
  services.elasticsearch.package = pkgs.opensearch;

  services.rabbitmq.enable = true;
  services.rabbitmq.managementPlugin.enable = true;
}
