{ pkgs, ... }: {
  sops.secrets.cloudflareTunnelToken = {
    restartUnits = [ "cloudflare-tunnel.service" ];
  };

  systemd.services.cloudflare-tunnel = {
    description = "Cloudflare Tunnel";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      EnvironmentFile = "/run/secrets/cloudflareTunnelToken";
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared --no-autoupdate tunnel run --token \${CLOUDFLARE_TUNNEL_TOKEN}";
      DynamicUser = true;
      Restart = "always";
    };
  };
}
