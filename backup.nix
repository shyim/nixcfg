{ config, pkgs, ... }:

{
    systemd.timers.restic-backup = {
        wantedBy = [ "timers.target" ];
        timerConfig.Unit = "restic-backup.service";
        timerConfig.OnBootSec = "12h";
	timerConfig.OnUnitActiveSec = "12h";
    };

    systemd.services.restic-backup = {
        path = [ pkgs.openssh ];
        serviceConfig.EnvironmentFile = "/srv/restic-env";
        serviceConfig.Type = "oneshot";
        serviceConfig.User = "root";

        serviceConfig.ExecStart = "${pkgs.restic}/bin/restic backup /srv /root";
    };
}
