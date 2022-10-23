{ config, pkgs, ... }:

{
    systemd.services.screego = {
        wantedBy = [ "multi-user.target" ];
        environment = {
            SCREEGO_EXTERNAL_IP = "78.46.239.161,2a01:4f8:1c1e:cd09::";
            SCREEGO_TRUST_PROXY_HEADERS = "true";
            SCREEGO_AUTH_MODE = "none";
            SCREEGO_SERVER_ADDRESS = "127.0.0.1:5050";
	    SCREEGO_CLOSE_ROOM_WHEN_OWNER_LEAVES = "false";
        };
        serviceConfig.ExecStart = "${pkgs.screego}/bin/screego serve";
    };

    networking.firewall.allowedTCPPorts = [ 3478 ];
    networking.firewall.allowedUDPPorts = [ 3478 ];

    services.traefik.dynamicConfigOptions.http.routers.http-screego = {
        rule = "Host(`screen.fos.gg`)";
        middlewares = "web-redirect@file";
        entryPoints = ["web"];
    };

    services.traefik.dynamicConfigOptions.http.routers.screego = {
        rule = "Host(`screen.fos.gg`)";
        middlewares = "compress@file";
        service = "screego";
        entryPoints = ["websecure"];
        tls = {
            certResolver = "cf";
            domains = [
                {
                    main = "fos.gg";
                    sans = ["*.fos.gg" ];
                }
            ];
        };
    };

    services.traefik.dynamicConfigOptions.http.services = {
        screego.loadBalancer.servers = [{url = "http://127.0.0.1:5050";}];
    };
}
