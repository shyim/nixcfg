{ config, pkgs, ... }:

{
  systemd.services.rclone-private = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart = "${pkgs.rclone}/bin/rclone serve webdav Crypt-Privat: --config /srv/rclone/rclone.conf --addr 127.0.0.1:5000 --user $RCLONE_USERNAME --pass $RCLONE_PASSWORD";
  };


  services.traefik.dynamicConfigOptions.http.routers.rclone-private = {
    rule = "Host(`webdav.shyim.de`)";
    middlewares = "compress@file";
    service = "rclone-private";
    entryPoints = [ "websecure" ];
    tls = {
      certResolver = "cf";
      domains = [
        {
          main = "shyim.de";
          sans = [ "*.shyim.de" ];
        }
      ];
    };
  };

  services.traefik.dynamicConfigOptions.http.services = {
    rclone-private.loadBalancer.servers = [{ url = "http://127.0.0.1:5000"; }];
  };
}
