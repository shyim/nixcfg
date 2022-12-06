{ config, pkgs, ... }:

{
  services.openssh.enable = true;

  # Caddy
  services.caddy.enable = true;

  # The Lounge
  services.thelounge.enable = true;
  services.thelounge.extraConfig = {
    reverseProxy = true;
    host = "unix:/var/run/thelounge/web.sock";
  };
  systemd.services.thelounge.serviceConfig = {
    StateDirectory = "thelounge";
    RuntimeDirectory = "thelounge";
    StateDirectoryMode = "0750";
    RuntimeDirectoryMode = "0750";
  };

  services.caddy.virtualHosts."http://irc.shyim.de" = {
    extraConfig = ''
      reverse_proxy unix:/var/run/thelounge/web.sock
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