{ pkgs, ... }:
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
    allowedUDPPorts = [ 443 ];
  };
}
