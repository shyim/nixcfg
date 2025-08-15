{ pkgs, config, ... }:
{
  imports = [
    ./services/wakapi.nix
    ./services/traefik.nix
    ./services/alloy.nix
    ./services/swdemo.nix
  ];

  services.openssh.enable = true;

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [ 443 51821 ];
  };

  sops.secrets.wireguardServerKey = {};

  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 51821;
      privateKeyFile = config.sops.secrets.wireguardServerKey.path;

      peers = [
        {
          name = "Nas";
          publicKey = "a3Ns5ofaaqCBkrnnKX9HNyz763GzJeiueD8Fx1YV9AM=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        {
          name = "Mac";
          publicKey = "WRK+Uma2oNAe0i1i/8WQy2zfPEEVdBBHRAmA6+wMRzI=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
      ];
    };
  };
}
