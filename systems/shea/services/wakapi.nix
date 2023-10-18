{ config
, pkgs
, flake
, ...
}: {
  users.users.wakapi = {
    description = "The wakapi service user";
    group = "nginx";
    isSystemUser = true;
  };

  sops.secrets = {
    wakapi = {
      owner = "wakapi";
    };
  };

  systemd.services.wakapi = {
    wantedBy = [ "multi-user.target" ];
    after = [ "mysql.service" ];
    environment = {
      ENVIRONMENT = "prod";
      WAKAPI_PASSWORD_SALT = "";
      WAKAPI_INSECURE_COOKIES = "false";
      WAKAPI_LISTEN_IPV4 = "";
      WAKAPI_LISTEN_IPV6 = "";
      WAKAPI_LISTEN_SOCKET = "/run/wakapi/web.sock";
      WAKAPI_DB_HOST = "localhost";
      WAKAPI_DB_SOCKET = "/run/mysqld/mysqld.sock";
      WAKAPI_DB_PORT = "3306";
      WAKAPI_DB_USER = "wakapi";
      WAKAPI_DB_NAME = "wakapi";
      WAKAPI_DB_TYPE = "mysql";
      WAKAPI_MAIL_ENABLED = "true";
      WAKAPI_MAIL_PROVIDER = "smtp";
      WAKAPI_MAIL_SENDER = "Wakapi <contact@fos.gg>";
      WAKAPI_MAIL_SMTP_HOST = "smtp.mail.me.com";
      WAKAPI_MAIL_SMTP_PORT = "587";
      WAKAPI_MAIL_SMTP_USER = "s.sayakci@icloud.com";
    };
    serviceConfig = {
      EnvironmentFile = config.sops.secrets.wakapi.path;
      ExecStart = "${flake.packages."aarch64-linux".wakapi}/bin/wakapi -config ${pkgs.writeText "wakapi.yaml" ""}";
      User = "wakapi";
      Group = "nginx";
      RuntimeDirectory = "wakapi";
      RuntimeDirectoryMode = "0770";
      UMask = "0002";
    };
  };

  services.nginx.virtualHosts."time.fos.gg" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://unix:/run/wakapi/web.sock";
      proxyWebsockets = true;
    };
  };
}
