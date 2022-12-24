{ config
, pkgs
, ...
}: {
  systemd.services.rclone-restic = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    serviceConfig.ExecStart = "${pkgs.rclone}/bin/rclone serve restic Backup:backup/shea --config /srv/rclone/rclone.conf --addr 127.0.0.1:7465";
  };

  systemd.services.restic = {
    wantedBy = [ "multi-user.target" ];
    after = [ "rclone-restic.service" ];
    environment = {
      RESTIC_REPOSITORY = "rest:http://localhost:7465/";
    };
    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${pkgs.restic}/bin/restic backup /var/lib/mysql /var/lib/thelounge";
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
