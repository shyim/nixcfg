{ config, ... }:
{
  sops.secrets.wakapi = {};

  services.docker-compose.wakapi.config = {
    services.wakapi = {
      image = "ghcr.io/muety/wakapi:2.13.4";
      labels = [
        "traefik.enable=true"
        "traefik.http.routers.wakapi.entrypoints=websecure"
        "traefik.http.routers.wakapi.rule=Host(`time.fos.gg`)"
        "traefik.http.routers.wakapi.tls=true"
        "traefik.http.routers.wakapi.tls.certresolver=cloudflare"
        "traefik.http.routers.wakapi.tls.domains[0].main=fos.gg"
        "traefik.http.routers.wakapi.tls.domains[0].sans=*.fos.gg"

        "traefik.http.middlewares.wakapi-compress.compress=true"
        "traefik.http.middlewares.wakapi-compress.compress.encodings=zstd,gzip"
        "traefik.http.routers.wakapi.middlewares=wakapi-compress"
      ];
      environment = {
        ENVIRONMENT = "prod";
        WAKAPI_PASSWORD_SALT = "";
        WAKAPI_DB_TYPE = "mysql";
        WAKAPI_DB_HOST = "mysql-215e415d-shyim-9c2d.a.aivencloud.com";
        WAKAPI_DB_PORT = "11754";
        WAKAPI_DB_USER = "avnadmin";
        WAKAPI_DB_NAME = "defaultdb";
        WAKAPI_MAIL_ENABLED = "true";
        WAKAPI_MAIL_PROVIDER = "smtp";
        WAKAPI_MAIL_SENDER = "Wakapi <contact@fos.gg>";
        WAKAPI_MAIL_SMTP_HOST = "email-smtp.eu-central-1.amazonaws.com";
        WAKAPI_MAIL_SMTP_PORT = "587";
        WAKAPI_MAIL_SMTP_TLS = "false";
      };
      env_file = config.sops.secrets.wakapi.path;
    };
  };
}
