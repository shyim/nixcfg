{ pkgs, config, ... }: {
  sops.secrets.cfDNSToken = {};

  security.acme = {
    acceptTerms = true;
    defaults.email = "acme@shyim.de";
    certs."shyim.de" = {
      dnsProvider = "cloudflare";
      extraDomainNames = [ "*.shyim.de" ];
      environmentFile = "/run/secrets/cfDNSToken";
  };
};

  services.caddy = {
    enable = true;
    virtualHosts."jellyfin.shyim.de" = {
      useACMEHost = "shyim.de";
      extraConfig = ''
        reverse_proxy localhost:8096
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ 443 ];
}