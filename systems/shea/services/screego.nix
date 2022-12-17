{ config, pkgs, myFlake, ... }:

{
  users.users.screego = {
    description = "The screego service user";
    group = "caddy";
    isSystemUser = true;
  };

  systemd.services.screego = {
    wantedBy = [ "multi-user.target" ];
    environment = {
      SCREEGO_EXTERNAL_IP = "138.2.153.89,2603:c020:800e:2300:af23:304d:7d5c:bed8";
      SCREEGO_TRUST_PROXY_HEADERS = "true";
      SCREEGO_AUTH_MODE = "none";
      SCREEGO_SERVER_ADDRESS = "127.0.0.1:3412";
      SCREEGO_CLOSE_ROOM_WHEN_OWNER_LEAVES = "false";
    };
    serviceConfig = {
      ExecStart = "${myFlake.packages."aarch64-linux".screego}/bin/screego serve";
      User = "screego";
      Group = "caddy";
      RuntimeDirectory = "screego";
      RuntimeDirectoryMode = "0770";
      UMask = "0002";
    };
  };

  networking.firewall.allowedTCPPorts = [ 3478 ];
  networking.firewall.allowedUDPPorts = [ 3478 ];

  services.caddy.virtualHosts."screen.fos.gg" = {
    extraConfig = ''
      reverse_proxy 127.0.0.1:3412
      encode gzip
    '';
  };
}
