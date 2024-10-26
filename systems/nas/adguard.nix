{ ... }: {
  services.adguardhome = {
    enable = true;
    port = 3000;
  };

  services.caddy.virtualHosts."snorlax.bunny-chickadee.ts.net" = {
    extraConfig = ''
      reverse_proxy 127.0.0.1:3000
    '';
  };
}
