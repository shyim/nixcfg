{ config, ... }: {
  services.mysqlBackup = {
    enable = true;
    databases = [ "wakapi" ];
  };

  sops.secrets.rclone_config = {
    owner = "root";
  };

  sops.secrets.restic_secret = {
    owner = "root";
  };

  services.restic.backups.shea = {
    paths = [
      "/var/lib/thelounge"
      "/var/lib/mysql"
    ];
    initialize = true;
    repository = "rclone:Storagebox:shea";
    rcloneConfigFile = config.sops.secrets.rclone_config.path;
    passwordFile = config.sops.secrets.restic_secret.path;
  };
}
