{ pkgs, ... }:
{
  imports = [
    ./services/wakapi.nix
    ./services/shopmon.nix
    ./services/traefik.nix
  ];

  services.openssh.enable = true;

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [ 443 ];
  };
}
