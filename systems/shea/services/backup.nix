{ config
, pkgs
, ...
}: {
  sops.secrets.rclone_config = {
    restartUnits = [ "rclone-restic.service" ];
  };
  sops.secrets.restic_env = {
    restartUnits = [ "rclone-restic.service" ];
  };

  systemd.services.rclone-restic = {
    requires = [ "network-online.target" ];
    partOf = [ "restic.service" ];
    serviceConfig.ExecStart = "${pkgs.rclone}/bin/rclone serve restic Dropbox:shyim/backup/shea --config ${config.sops.secrets.rclone_config.path} --addr 127.0.0.1:7465";
    serviceConfig.Type = "notify";
  };

  systemd.services.restic = {
    requires = [ "rclone-restic.service" ];
    environment = {
      RESTIC_REPOSITORY = "rest:http://localhost:7465/";
    };
    serviceConfig.EnvironmentFile = config.sops.secrets.restic_env.path;
    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${pkgs.restic}/bin/restic backup /var/lib/mysql /var/lib/thelounge /var/lib/paperless";
  };

  systemd.timers.restic = {
    wantedBy = [ "timers.target" ];
    partOf = [ "restic.service" ];
    timerConfig = {
      OnCalendar = [ "daily" ];
      Unit = "restic.service";
    };
  };
}
