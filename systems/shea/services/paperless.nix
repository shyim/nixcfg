{ config
, pkgs
, flake
, ...
}: {
  services.paperless = {
    enable = true;
  };

  services.caddy.virtualHosts."paperless.shyim.de" = {
    extraConfig = ''
      reverse_proxy http://${config.services.paperless.address}:${toString config.services.paperless.port}
      encode gzip
    '';
  };

  systemd.services.paperless-scheduler.requires = [ "rclone-paperless.service" ];

  systemd.services.rclone-paperless = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    path = [
      pkgs.fuse3
    ];
    serviceConfig = {
      Type = "notify";
      ExecStart = "${pkgs.rclone}/bin/rclone mount DropboxDocuments: --allow-other --vfs-cache-mode=minimal --config ${config.sops.secrets.rclone_config.path} /var/lib/paperless/media";
      ExecStop = "${pkgs.fuse3}/bin/fusermount -uz /var/lib/paperless/media";
    };
  };
}
