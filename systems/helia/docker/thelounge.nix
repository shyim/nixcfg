{ config, pkgs, ... }:

{
  services.docker-compose.thelounge.config = {
    services.lounge = {
      image = "thelounge/thelounge:latest";
      environment = [
        "NODE_ENV=production"
      ];
      labels = [
        "traefik.enable=true"
        "traefik.http.routers.thelounge.entrypoints=websecure"
        "traefik.http.routers.thelounge.rule=Host(`irc.shyim.de`)"
        "traefik.http.routers.thelounge.tls=true"
        "traefik.http.routers.thelounge.tls.certresolver=cf"
        "traefik.http.routers.thelounge.tls.domains[0].main=shyim.de"
        "traefik.http.routers.thelounge.tls.domains[0].sans=*.shyim.de"
      ];
      volumes = [ "/srv/docker/thelounge/data:/var/opt/thelounge" ];
    };
  };
}
