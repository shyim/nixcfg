{ config
, pkgs
, ...
}: {
  sops.secrets.rclone_private = {
    restartUnits = [ "rclone-private.service" ];
  };
  sops.secrets.rclone_tdrive = {
    restartUnits = [ "rclone-tdrive.service" ];
  };

  systemd.services.rclone-private = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    serviceConfig.EnvironmentFile = config.sops.secrets.rclone_private.path;
    serviceConfig.ExecStart = "${pkgs.rclone}/bin/rclone serve webdav Crypt-Privat: --config ${config.sops.secrets.rclone_config.path} --addr 127.0.0.1:5000 --user $RCLONE_USERNAME --pass $RCLONE_PASSWORD";
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
    serviceConfig.EnvironmentFile = config.sops.secrets.rclone_tdrive.path;
    serviceConfig.ExecStart = "${pkgs.rclone}/bin/rclone serve sftp TDrive: --config ${config.sops.secrets.rclone_config.path} --addr :5001 --user $RCLONE_USERNAME --pass $RCLONE_PASSWORD --drive-chunk-size=128M --buffer-size=128M --read-only";
  };
}
