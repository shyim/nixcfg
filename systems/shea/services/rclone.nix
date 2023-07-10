{ config
, pkgs
, lib
, flake
, ...
}: {
  sops.secrets.rclone_config = {
    restartUnits = [ "rclone-cloudreve.service" ];
  };

  users.users.cloudreve = {
    isSystemUser = true;
    group = "caddy";
  };

  systemd.services.rclone-cloudreve = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    path = [
      pkgs.fuse3
    ];
    serviceConfig = {
      Type = "notify";
      ExecStart = "${pkgs.rclone}/bin/rclone mount DropboxCloudreve: --allow-other --vfs-cache-mode=minimal --config ${config.sops.secrets.rclone_config.path} /var/lib/cloudreve/uploads";
      ExecStop = "${pkgs.fuse3}/bin/fusermount -uz /var/lib/cloudreve/uploads";
    };
  };

  systemd.services.cloudreve = {
    wantedBy = [ "multi-user.target" ];
    requires = [ "rclone-cloudreve.service" ];
    after = [ "network-online.target" ];
    path = [
      pkgs.vips
    ];
    serviceConfig = {
      ExecStart = pkgs.writeShellScript "cloudreve" ''
        rm -f /var/lib/cloudreve/cloudreve
        cp ${flake.packages."aarch64-linux".cloudreve}/bin/cloudreve /var/lib/cloudreve/cloudreve

        /run/wrappers/bin/mount | grep /var/lib/cloudreve/uploads

        if [ $? -ne 0 ]; then
          echo "Mount not found"
          exit 1
        fi

        exec /var/lib/cloudreve/cloudreve
      '';
      WorkingDirectory = "/var/lib/cloudreve";
      User = "cloudreve";
      Group = "caddy";
      RuntimeDirectory = "cloudreve";
      RuntimeDirectoryMode = "0770";
      UMask = "0002";
    };
  };

  services.caddy.virtualHosts."drive.shyim.de" = {
    extraConfig = ''
      reverse_proxy http://127.0.0.1:5212
      encode gzip
    '';
  };
}
