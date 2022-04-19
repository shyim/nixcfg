{ config, pkgs, ... }:

{
    services.docker-compose.hedgedoc.config = {
        services.database = {
            image = "postgres:13.2-alpine";
            env_file = "/srv/docker/hedgedoc/.db.env";
            volumes = ["/srv/docker/hedgedoc/postgres:/var/lib/postgresql/data"];
        };

        services.hedgedoc = {
            image = "quay.io/hedgedoc/hedgedoc:1.9.3";
            labels = [
                "traefik.enable=true"
                "traefik.http.routers.http-hedgedoc.entrypoints=web"
                "traefik.http.routers.http-hedgedoc.rule=Host(`md.shyim.de`)"
                "traefik.http.routers.http-hedgedoc.middlewares=web-redirect@file"
                "traefik.http.routers.hedgedoc.entrypoints=websecure"
                "traefik.http.routers.hedgedoc.rule=Host(`md.shyim.de`)"
                "traefik.http.routers.hedgedoc.tls=true"
                "traefik.http.routers.hedgedoc.middlewares=compress@file"
                "traefik.http.routers.hedgedoc.tls.certresolver=cf"
                "traefik.http.routers.hedgedoc.tls.domains[0].main=shyim.de"
                "traefik.http.routers.hedgedoc.tls.domains[0].sans=*.shyim.de"
            ];
            env_file = "/srv/docker/hedgedoc/.app.env";
            depends_on = ["database"];
            volumes = ["/srv/docker/hedgedoc/upload-data:/hedgedoc/public/uploads"];
        };
    };
}