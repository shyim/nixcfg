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
      opcache.interned_strings_buffer=20
      opcache.enable_cli = 1
      zend.assertions = 0
      short_open_tag = 0
      zend.detect_unicode=0
      realpath_cache_ttl=3600
      date.timezone=Europe/Berlin
    '';
    php82 = phps.packages.aarch64-darwin.php82.buildEnv {
      extensions = { all, enabled }: with all; enabled ++ [ redis amqp ];
      extraConfig = phpIni;
    };
    php82Cov = phps.packages.aarch64-darwin.php82.buildEnv {
      extensions = { all, enabled }: with all; enabled ++ [ redis amqp ];
      extraConfig = phpIni;
    };
in
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    php82
    php82.packages.composer
    (pkgs.writeShellScriptBin "php-cov" ''
        exec ${php82Cov}/bin/php "$@"
      ''
    )
  ];

  services.blackfire.enable = true;

  services.phpfpm.pools.php81 = {
    phpPackage = php82;
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