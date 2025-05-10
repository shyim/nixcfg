{ pkgs, ...}: {
  imports = [
    ./services/wakapi.nix
  ];

  services.openssh.enable = true;

  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "both";
    extraUpFlags = [ "--ssh" "--advertise-exit-node" ];

    derper = {
      enable = true;
      openFirewall = true;
      verifyClients = true;
      domain = "derper.shyim.de";
    };
  };

  services.networkd-dispatcher = {
    enable = true;
    rules."50-tailscale" = {
      onState = ["routable"];
      script = ''
        #!${pkgs.runtimeShell}
        ${pkgs.ethtool}/bin/ethtool -K enp0s3 rx-udp-gro-forwarding on rx-gro-list off
      '';
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPorts = [ 443 ];
  };

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;

    virtualHosts."derper.shyim.de" = {
      enableACME = true;
    };
  };

  security.acme = {
    acceptTerms = true;
    email = "acme@shyim.de";
  };
}