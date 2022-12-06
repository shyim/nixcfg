{ config, pkgs, ... }:

{
  services.thelounge.enable = true;
  services.thelounge.extraConfig = {
    reverseProxy = true;
    host = "unix:/run/thelounge/web.sock";
  };

  systemd.services.thelounge.serviceConfig = {
    Group = "caddy";
    StateDirectory = "thelounge";
    RuntimeDirectory = "thelounge";
    StateDirectoryMode = "0770";
    RuntimeDirectoryMode = "0770";
    UMask = "0002";
  };

  services.caddy.virtualHosts."irc.shyim.de" = {
    extraConfig = ''
      reverse_proxy unix/run/thelounge/web.sock
      encode gzip
    '';
  };
}
