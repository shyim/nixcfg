{ ... }:
{
  users.users.shyim = {
    isNormalUser = true;
  };

  users.users.thelostsandman = {
    isNormalUser = true;
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "min protocol" = "SMB3";
        "vfs objects" = "catia fruit streams_xattr";
        "fruit:nfs_aces" = "no";
        "fruit:metadata" = "stream";
        "fruit:model" = "MacSamba";
        "fruit:posix_rename" = "yes";
        "fruit:veto_appledouble" = "no";
        "fruit:wipe_intentionally_left_blank_rfork" = "yes";
        "fruit:delete_empty_adfiles" = "yes";
        "server min protocol" = "SMB3";
        "wins support" = "yes";
        "dns proxy" = "yes";
        "hosts allow" = "192.168.31. 127.0.0.1 100.64.0.0/10 localhost";
        "hosts deny" = "0.0.0.0/0";
      };
      jellyfin = {
        "path" = "/mnt/jellyfin";
        "valid users" = "shyim thelostsandman";
        "read only" = "yes";
        "browseable" = "yes";
      };
      switch = {
        "path" = "/mnt/switch";
        "valid users" = "shyim";
        "read only" = "no";
        "browseable" = "yes";
        "create mask" = "0770";
        "directory mask" = "0770";
      };
      shyim = {
        "path" = "/mnt/shyim";
        "valid users" = "shyim";
        "read only" = "no";
        "browseable" = "yes";
        "create mask" = "0770";
        "directory mask" = "0770";
      };
      nvme = {
        "path" = "/mnt/nvme";
        "valid users" = "shyim";
        "read only" = "no";
        "browseable" = "yes";
        "create mask" = "0770";
        "directory mask" = "0770";
      };
      timemachine = {
        "path" = "/mnt/timemachine";
        "comment" = "Apple Backup Shared Folder";
        "fruit:time machine" = "yes";
        "valid users" = "shyim";
        "read only" = "no";
        "browseable" = "yes";
        "create mask" = "0770";
        "directory mask" = "0770";
      };
    };
  };
}
