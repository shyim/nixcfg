{ config
, pkgs
, ...
}: {
  systemd.services.rclone-private = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    serviceConfig.ExecStart = "${pkgs.rclone}/bin/rclone serve webdav Crypt-Privat: --config /srv/rclone/rclone.conf --addr 127.0.0.1:5000 --user $RCLONE_USERNAME --pass $RCLONE_PASSWORD";
  };

  services.caddy.virtualHosts."webdav.shyim.de" = {
    extraConfig = ''
      reverse_proxy :5000
      encode gzip
    '';
  };

  systemd.services.rclone-tdrive = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    serviceConfig.ExecStart = "${pkgs.rclone}/bin/rclone serve ftp TDrive: --config /srv/rclone/rclone.conf --addr 100.111.47.100:5001 --user $RCLONE_USERNAME --pass $RCLONE_PASSWORD";
  };
}
