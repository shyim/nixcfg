{ config
, pkgs
, ...
}: {
  services.caddy.virtualHosts."http://nut.shyim.de" = {
    extraConfig = ''
      reverse_proxy unix/var/run/nut/web.sock
      encode gzip
    '';
  };

  services.caddy.virtualHosts."https://nut.shyim.de" = {
    extraConfig = ''
      reverse_proxy unix/var/run/nut/web.sock
      encode gzip
    '';
  };

  users.users.nut = {
    description = "The nut service user";
    group = "caddy";
    isSystemUser = true;
  };

  systemd.services.nut = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "/opt/nut server --socket /var/run/nut/web.sock";
      User = "nut";
      Group = "caddy";
      StateDirectory = "nut";
      RuntimeDirectory = "nut";
      StateDirectoryMode = "0770";
      RuntimeDirectoryMode = "0770";
      UMask = "0002";
    };
  };
}
