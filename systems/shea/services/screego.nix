{ config
, pkgs
, myFlake
, ...
}: {
  sops.secrets.coturn_secret = {
    owner = "turnserver";
    restartUnits = [ "coturn.service" ];
  };

  sops.secrets.screego_env = {
    restartUnits = [ "screego.service" ];
  };

  users.users.screego = {
    description = "The screego service user";
    group = "caddy";
    isSystemUser = true;
  };

  services.coturn = {
    enable = true;
    use-auth-secret = true;
    static-auth-secret-file = config.sops.secrets.coturn_secret.path;
    realm = "shea.shyim.de";
    extraConfig = ''
      #external-ip=2603:c020:800e:2300:af23:304d:7d5c:bed8
      external-ip=138.2.153.89/10.0.0.106
      relay-device=enp0s3
      listening-device=enp0s3
      no-cli

      #allocation-default-address-family=keep
      # Fixes IPv6, but breaks IPv4
      # keep-address-family
    '';
    listening-ips = [
      "10.0.0.106"
      "2603:c020:800e:2300:af23:304d:7d5c:bed8"
    ];
    relay-ips = [
      "10.0.0.106"
      "2603:c020:800e:2300:af23:304d:7d5c:bed8"
    ];
    min-port = 62000;
    max-port = 64000;
  };

  systemd.services.screego = {
    wantedBy = [ "multi-user.target" ];
    environment = {
      SCREEGO_TURN_EXTERNAL_IP = "2603:c020:800e:2300:af23:304d:7d5c:bed8,138.2.153.89";
      SCREEGO_TURN_EXTERNAL_PORT = "3478";
      SCREEGO_TRUST_PROXY_HEADERS = "true";
      SCREEGO_AUTH_MODE = "none";
      SCREEGO_SERVER_ADDRESS = "127.0.0.1:3412";
      SCREEGO_CLOSE_ROOM_WHEN_OWNER_LEAVES = "false";
    };
    serviceConfig = {
      ExecStart = "${myFlake.packages."aarch64-linux".screego}/bin/screego serve";
      EnvironmentFile = config.sops.secrets.screego_env.path;
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
