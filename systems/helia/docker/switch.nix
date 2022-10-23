{ config, pkgs, ... }:

{
  services.docker-compose.switch.config = {
    services.switch = {
      image = "ghcr.io/shyim/switch-image-server";
      environment = {
        STORAGE_DIR = "/files";
      };
      labels = [
        "traefik.enable=true"
        "traefik.http.routers.myswitch.entrypoints=websecure"
        "traefik.http.routers.myswitch.rule=Host(`myswitch.shyim.de`)"
        "traefik.http.routers.myswitch.tls=true"
        "traefik.http.routers.myswitch.tls.certresolver=cf"
        "traefik.http.routers.myswitch.tls.domains[0].main=shyim.de"
        "traefik.http.routers.myswitch.tls.domains[0].sans=*.shyim.de"
      ];
      volumes = [ "/srv/docker/switch/images:/files" ];
    };
  };
}
