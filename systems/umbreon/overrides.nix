self: super:
let
in {
  custom-php81 = super.pkgs.php81.buildEnv {
    extensions = { all, enabled }: with all; enabled ++ [ redis blackfire ];
    extraConfig = ''
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
  };
}
