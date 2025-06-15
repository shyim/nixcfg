{ pkgs, ... }:
{
  imports = [
    ./services/wakapi.nix
    ./services/shopmon.nix
  ];

  services.openssh.enable = true;

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [ 443 ];
  };

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
  };

  security.acme = {
    acceptTerms = true;
    email = "acme@shyim.de";
  };
}
