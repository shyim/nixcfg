{ config
, pkgs
, ...
}: {
  services.thelounge.enable = true;
  services.thelounge.extraConfig = {
    reverseProxy = true;
    host = "unix:/run/thelounge/web.sock";
  };

  systemd.services.thelounge.serviceConfig = {
    Group = "nginx";
    StateDirectory = "thelounge";
    RuntimeDirectory = "thelounge";
    StateDirectoryMode = "0770";
    RuntimeDirectoryMode = "0770";
    UMask = "0002";
  };

  services.nginx.virtualHosts."irc.shyim.de" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://unix:/run/thelounge/web.sock";
      proxyWebsockets = true;
    };
  };
}
