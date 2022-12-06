{ config, pkgs, ... }:

{
  services.openssh.enable = true;

  # Caddy
  services.caddy.enable = true;

  # The Lounge
  services.thelounge.enable = true;
  services.thelounge.extraConfig = {
    reverseProxy = true;
    host = "unix:/run/thelounge.sock";
  };

  systemd.sockets.thelounge = {
    description = "The Lounge Socket";
    wantedBy = [ "sockets.target" ];
    socketConfig = {
      ListenStream = "/run/thelounge.sock";
      SocketMode = "0660";
      SocketUser = "root";
      SocketGroup = "thelounge";
    };
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