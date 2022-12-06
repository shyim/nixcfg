{ config, pkgs, ... }:

{
  services.openssh.enable = true;

  # Caddy
  services.caddy.enable = true;

  # The Lounge
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
  

  # MySQL
  services.mysql.enable = true;
  services.mysql.package = pkgs.mysql80;
  services.mysql.initialDatabases = [ { name = "wakapi"; } ];
  services.mysql.ensureUsers = [
    {
      name = "wakapi";
      ensurePermissions = {
        "wakapi.*" = "ALL PRIVILEGES";
      };
    }
  ];
}