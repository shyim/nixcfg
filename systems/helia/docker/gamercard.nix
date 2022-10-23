{ config, pkgs, ... }:

{
    services.docker-compose.gamercard.config = {
        services.mysql = {
            image = "mysql:8.0";
            environment = {
                "MYSQL_ROOT_PASSWORD" =  "gamercard";
                "MYSQL_USER" =  "gamercard";
                "MYSQL_PASSWORD" =  "gamercard";
                "MYSQL_DATABASE" =  "gamercard";
            };
            volumes = ["/srv/docker/gamercard/db:/var/lib/mysql"];
        };

        services.gamercard = {
            image = "ghcr.io/shyim/gamercard";
            healthcheck.disable = true;
            labels = [
                "traefik.enable=true"
                "traefik.http.routers.gamercard.entrypoints=websecure"
                "traefik.http.routers.gamercard.rule=Host(`api.gamercard.co`)"
                "traefik.http.routers.gamercard.tls=true"
                "traefik.http.routers.gamercard.middlewares=compress@file"
                "traefik.http.routers.gamercard.tls.certresolver=cf"
                "traefik.http.routers.gamercard.tls.domains[0].main=gamercard.co"
                "traefik.http.routers.gamercard.tls.domains[0].sans=*.gamercard.co"
            ];
        };
    };
}