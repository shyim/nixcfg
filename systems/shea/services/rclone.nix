{ config, pkgs, ... }:

{
  systemd.services.rclone-private = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart = "${pkgs.rclone}/bin/rclone serve webdav Crypt-Privat: --config /srv/rclone/rclone.conf --addr 127.0.0.1:5000 --user $RCLONE_USERNAME --pass $RCLONE_PASSWORD";
  };

  services.caddy.virtualHosts."webdav.shyim.de" = {
    extraConfig = ''
      reverse_proxy :5000
      encode gzip
    '';
  };
}
