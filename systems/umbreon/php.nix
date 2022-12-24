{ pkgs
, phps
, ...
}:
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
    extensions =
      { all
      , enabled
      ,
      }:
        with all; enabled ++ [ redis amqp (blackfire // { extensionName = "blackfire"; }) ];
    extraConfig = phpIni;
  };
in
{
  environment.systemPackages = with pkgs; [
    phpPkg
    phpPkg.packages.composer
  ];
}
