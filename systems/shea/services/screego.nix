{ config, pkgs, myFlakePackages, ... }:

{
  systemd.services.screego = {
    wantedBy = [ "multi-user.target" ];
    environment = {
      SCREEGO_EXTERNAL_IP = "138.2.153.89";
      SCREEGO_TRUST_PROXY_HEADERS = "true";
      SCREEGO_AUTH_MODE = "none";
      SCREEGO_SERVER_ADDRESS = "127.0.0.1:5050";
      SCREEGO_CLOSE_ROOM_WHEN_OWNER_LEAVES = "false";
    };
    serviceConfig.ExecStart = "${myFlakePackages.screego}/bin/screego serve";
  };

  networking.firewall.allowedTCPPorts = [ 3478 ];
  networking.firewall.allowedUDPPorts = [ 3478 ];

  services.caddy.virtualHosts."screen.fos.gg" = {
    extraConfig = ''
      reverse_proxy :5050
      encode gzip
    '';
  };
}
