{ config, pkgs, ... }:

{
  services.caddy.virtualHosts."http://nut.shyim.de" = {
    extraConfig = ''
      reverse_proxy :9000
      encode gzip
    '';
  };
}
