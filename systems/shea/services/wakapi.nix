{ config, ... }:
{
  services.nginx.virtualHosts."time.fos.gg" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://unix:/run/wakapi/web.sock";
      proxyWebsockets = true;
    };
  };

  sops.secrets = {
    wakapi = {
      owner = "wakapi";
    };
  };

  services.wakapi = {
    enable = true;
    passwordSalt = "";
    smtpPasswordFile = config.sops.secrets.wakapi.path;
    settings = {
      server = {
        public_url = "https://time.fos.gg";
        listen_ipv4 = "";
        listen_ipv6 = "";
        listen_socket = "/run/wakapi/web.sock";
      };
      db = {
        dialect = "mysql";
        host = "mysql-215e415d-shyim-9c2d.a.aivencloud.com";
        port = 11754;
        user = "avnadmin";
        name = "defaultdb";
      };
      mail = {
        enabled = true;
        provider = "smtp";
        sender = "Wakapi <contact@fos.gg>";
        smtp = {
          host = "email-smtp.eu-central-1.amazonaws.com";
          port = 587;
          tls = false;
        };
      };
    };
  };
}
