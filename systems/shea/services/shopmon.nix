{ config, ... }:
{
  services.nginx.virtualHosts."shopmon.fos.gg" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3000";
      proxyWebsockets = true;
    };
  };

  services.nginx.virtualHosts."shopmon-staging.fos.gg" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3001";
      proxyWebsockets = true;
    };
  };

  services.nginx.virtualHosts."demo.fos.gg" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3070";
      proxyWebsockets = true;
    };
  };
}
