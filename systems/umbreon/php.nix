{ pkgs, phps, ... }:

let
  phpIni = ''
      memory_limit = 2G
      pdo_mysql.default_socket=/tmp/mysql.sock
      mysqli.default_socket=/tmp/mysql.sock
      blackfire.agent_socket = "tcp://127.0.0.1:8307";
      realpath_cache_ttl=3600
      session.gc_probability=0
      display_errors = On
      error_reporting = E_ALL
      assert.active=0
      opcache.memory_consumption=256M
      opcache.interned_strings_buffer=20
      opcache.enable_cli = 1
      zend.assertions = 0
      short_open_tag = 0
      zend.detect_unicode=0
      realpath_cache_ttl=3600
      date.timezone=Europe/Berlin
    '';
    phpPkg = phps.packages.aarch64-darwin.php81.buildEnv {
      extensions = { all, enabled }: with all; enabled ++ [ redis amqp (blackfire// { extensionName = "blackfire"; }) ];
      extraConfig = phpIni;
    };
in
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    phpPkg
    phpPkg.packages.composer
  ];

  services.blackfire.enable = true;

  services.phpfpm.pools.php81 = {
    phpPackage = phpPkg;
    settings = {
      "pm" = "dynamic";
      "pm.max_children" = 32;
      "pm.max_requests" = 500;
      "pm.start_servers" = 10;
      "pm.min_spare_servers" = 10;
      "pm.max_spare_servers" = 32;
      "php_admin_value[error_log]" = "stderr";
      "php_admin_flag[log_errors]" = true;
      "catch_workers_output" = true;
    };
  };
}
