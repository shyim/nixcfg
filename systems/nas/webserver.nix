{
  pkgs,
  config,
  ...
}:
{
  # Caddy QUIC Recommandation
  boot.kernel.sysctl."net.core.rmem_max" = 26214400;
  boot.kernel.sysctl."net.core.wmem_max" = 26214400;

  sops.secrets.cfDNSToken = { };

  security.acme = {
    acceptTerms = true;
    defaults.email = "acme@shyim.de";
    certs."shyim.de" = {
      dnsProvider = "cloudflare";
      extraDomainNames = [ "*.shyim.de" ];
      environmentFile = "/run/secrets/cfDNSToken";
    };
  };

  sops.secrets.tailscale = {
    restartUnits = [ "caddy.service" ];
  };

  sops.secrets.cloudflareTunnelToken = {
    restartUnits = [ "cloudflare-tunnel.service" ];
  };

  systemd.services.cloudflare-tunnel = {
    description = "Cloudflare Tunnel";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      EnvironmentFile = "/run/secrets/cloudflareTunnelToken";
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared --no-autoupdate tunnel run --token \${CLOUDFLARE_TUNNEL_TOKEN}";
      DynamicUser = true;
      Restart = "always";
    };
  };

  services.glances.enable = true;

  services.caddy = {
    enable = true;
    enableReload = false;
    environmentFile = "/run/secrets/tailscale";
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/tailscale/caddy-tailscale@v0.0.0-20250207163903-69a970c84556" ];
      hash = "sha256-wt3+xCsT83RpPySbL7dKVwgqjKw06qzrP2Em+SxEPto=";
    };
    virtualHosts."http://nut.shyim.de" = {
      extraConfig = ''
        reverse_proxy localhost:9000
      '';
    };
    virtualHosts."jellyfin.shyim.de" = {
      useACMEHost = "shyim.de";
      extraConfig = ''
        reverse_proxy localhost:8096
      '';
    };
    virtualHosts."jellyseerr.shyim.de" = {
      useACMEHost = "shyim.de";
      extraConfig = ''
        reverse_proxy localhost:5055
      '';
    };
    virtualHosts."https://radarr.bunny-chickadee.ts.net" = {
      extraConfig = ''
        bind tailscale/radarr
        reverse_proxy localhost:7878
      '';
    };
    virtualHosts."https://sonarr.bunny-chickadee.ts.net" = {
      extraConfig = ''
        bind tailscale/sonarr
        reverse_proxy localhost:8989
      '';
    };
    virtualHosts."https://sabnzbd.bunny-chickadee.ts.net" = {
      extraConfig = ''
        bind tailscale/sabnzbd
        reverse_proxy localhost:8172
      '';
    };
    virtualHosts."https://glances.bunny-chickadee.ts.net" = {
      extraConfig = ''
        bind tailscale/glances
        reverse_proxy localhost:61208
      '';
    };
    virtualHosts."https://portainer.bunny-chickadee.ts.net" = {
      extraConfig = ''
        bind tailscale/portainer
        reverse_proxy localhost:9443 {
          transport http {
                tls
                tls_insecure_skip_verify
          }
        }
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  networking.firewall.allowedUDPPorts = [ 443 ];
}
