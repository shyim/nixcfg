{ config, ... }: {
  networking.firewall = {
      allowedUDPPorts = [ 51821 ];
  };

  sops.secrets.wireguardClientKey = {};

  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
      wg0 = {
        ips = [ "10.100.0.2/32" ];
        listenPort = 51821;

        privateKeyFile = config.sops.secrets.wireguardClientKey.path;

        peers = [
          {
            publicKey = "xF4rCUk/iNgggw2MRR3X6FYy7zJgDhSAj8VGrUlMLmI=";
            allowedIPs = [ "10.100.0.0/24" ];
            endpoint = "shea.shyim.de:51821";
            persistentKeepalive = 25;
          }
        ];
      };
    };
}
