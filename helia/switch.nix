{ config, pkgs, ... }:

{
services.traefik.dynamicConfigOptions.http.routers.http-nut = {
        rule = "Host(`nut.shyim.de`)";
        middlewares = "compress@file";
        service = "nut";
        entryPoints = ["web"];      
    };



    services.traefik.dynamicConfigOptions.http.routers.nut = {
        rule = "Host(`nut.shyim.de`)";
        middlewares = "compress@file";
        service = "nut";
        entryPoints = ["websecure"];
        tls = {
            certResolver = "cf";
            domains = [
                {
                    main = "shyim.de";
                    sans = ["*.shyim.de" ];
                }
            ];
        };
    };

   services.traefik.dynamicConfigOptions.http.services = {
        nut.loadBalancer.servers = [{url = "http://127.0.0.1:9000";}];
    };
}
