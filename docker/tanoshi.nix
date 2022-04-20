{ config, pkgs, ... }:

{
    services.docker-compose.tanoshi.config = {
        services.tanoshi = {
            image = "faldez/tanoshi:latest";
            network_mode = "container:wireguard";
            volumes = [ "/srv/docker/tanoshi/tanoshi:/tanoshi" ];
        };

        services.tunnel = {
            image = "cloudflare/cloudflared";
            network_mode = "container:wireguard";
            volumes = [
                "/srv/docker/tanoshi/cloudflare:/etc/cloudflared/"
            ];
            command = [ "tunnel" "run" ];
        };
    };
}