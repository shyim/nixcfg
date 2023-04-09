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
    serviceConfig = {
      EnvironmentFile = config.sops.secrets.rclone_private.path;
      ExecStart = "${pkgs.rclone}/bin/rclone serve webdav Crypt-Privat: --config ${config.sops.secrets.rclone_config.path} --addr unix:///run/rclone-private/web.sock";
      Group = "caddy";
      RuntimeDirectory = "rclone-private";
      RuntimeDirectoryMode = "0770";
      UMask = "0002";
    };
  };

  services.caddy.virtualHosts."webdav.shyim.de" = {
    extraConfig = ''
      basicauth {
        {$PRIVATE_WEBDAV_USERNAME} {$PRIVATE_WEBDAV_PASSWORD}
      }
      reverse_proxy unix/run/rclone-private/web.sock
      encode gzip
    '';
  };

  # TDrive

  systemd.services.rclone-tdrive-web = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      EnvironmentFile = config.sops.secrets.rclone_private.path;
      ExecStart = "${pkgs.rclone}/bin/rclone serve webdav TDrive: --config ${config.sops.secrets.rclone_config.path} --addr unix:///run/rclone-tdrive/web.sock --drive-chunk-size=128M --buffer-size=128M --read-only";
      Group = "caddy";
      RuntimeDirectory = "rclone-tdrive";
      RuntimeDirectoryMode = "0770";
      UMask = "0002";
    };
  };

  services.caddy.virtualHosts."tdrive.shyim.de" = {
    extraConfig = ''
      basicauth {
        {$TDRIVE_WEBDAV_USERNAME} {$TDRIVE_WEBDAV_PASSWORD}
      }
      reverse_proxy unix/run/rclone-tdrive/web.sock
      encode gzip
    '';
  };
}
