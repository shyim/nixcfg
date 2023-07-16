{ config
, pkgs
, ...
}: {
  services.nginx.virtualHosts."nut.shyim.de" = {
    enableACME = true;
    forceSSL = false;
    addSSL = true;
    locations."/" = {
      proxyPass = "http://unix:/var/run/nut/web.sock";
    };
  };

  users.users.nut = {
    description = "The nut service user";
    group = "nginx";
    isSystemUser = true;
  };

  systemd.services.nut = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "/opt/nut server --socket /var/run/nut/web.sock";
      User = "nut";
      Group = "nginx";
      StateDirectory = "nut";
      RuntimeDirectory = "nut";
      StateDirectoryMode = "0770";
      RuntimeDirectoryMode = "0770";
      UMask = "0002";
    };
  };
}
