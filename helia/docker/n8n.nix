{ config, pkgs, ... }:

{
    services.docker-compose.n8n.config = {
        services.n8n = {
            image = "n8nio/n8n:latest";
            environment = [
                "N8N_HOST=n8n.shyim.de"
                "N8N_PROTOCOL=https"
                "NODE_ENV=production"
                "WEBHOOK_TUNNEL_URL=https://n8n.shyim.de/"
                "GENERIC_TIMEZONE=Europe/Berlin"
            ];
            labels = [
                "traefik.enable=true"
                "traefik.http.routers.n8n.entrypoints=websecure"
                "traefik.http.routers.n8n.rule=Host(`n8n.shyim.de`)"
                "traefik.http.routers.n8n.tls=true"
                "traefik.http.routers.n8n.tls.certresolver=cf"
                "traefik.http.routers.n8n.tls.domains[0].main=shyim.de"
                "traefik.http.routers.n8n.tls.domains[0].sans=*.shyim.de"
            ];
            volumes = ["/srv/docker/n8n/data:/home/node/.n8n"];
        };
    };
}