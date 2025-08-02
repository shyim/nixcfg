{ config, ... }:
{
  sops.secrets.swdemo = { };

  services.docker-compose.swdemo.config = {
    services.shopware = {
      image = "ghcr.io/friendsofshopware/shopware-demo-environment:6.6.10";
      labels = [
        "traefik.enable=true"
        "traefik.http.routers.swdemo.entrypoints=websecure"
        "traefik.http.routers.swdemo.rule=Host(`demo.fos.gg`)"
        "traefik.http.routers.swdemo.tls=true"
        "traefik.http.routers.swdemo.tls.certresolver=cloudflare"
        "traefik.http.routers.swdemo.tls.domains[0].main=fos.gg"
        "traefik.http.routers.swdemo.tls.domains[0].sans=*.fos.gg"

        "traefik.http.middlewares.swdemo-compress.compress=true"
        "traefik.http.middlewares.swdemo-compress.compress.encodings=zstd,gzip"
        "traefik.http.routers.swdemo.middlewares=swdemo-compress"
      ];
      env_file = config.sops.secrets.swdemo.path;
      environment = {
        EXTENSIONS = "frosh/tools:* frosh/shopmon:*";
        TRUSTED_PROXIES = "REMOTE_ADDR";
        APP_URL = "https://demo.fos.gg";
      };
    };
  };
}
