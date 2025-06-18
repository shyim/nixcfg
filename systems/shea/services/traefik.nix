{ config, ... }: {
  sops.secrets.traefik = {};

  services.docker-compose.traefik.config = {
    services.traefik = {
      image = "traefik";
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock"
        "traefik_data:/data"
      ];
      env_file = config.sops.secrets.traefik.path;

      command = [
        "--entrypoints.web.address=:80"
        "--entrypoints.websecure.address=:443"

        # Metrics
        "--metrics.prometheus=true"
        "--metrics.prometheus.addrouterslabels=true"

        # Enable Docker provider
        "--providers.docker=true"
        "--providers.docker.exposedbydefault=false"

        # DNS Challenge for Cloudflare
        "--certificatesresolvers.cloudflare.acme.tlschallenge=false"
        "--certificatesresolvers.cloudflare.acme.dnschallenge=true"
        "--certificatesresolvers.cloudflare.acme.dnschallenge.provider=cloudflare"
        "--certificatesresolvers.cloudflare.acme.dnschallenge.resolvers=1.1.1.1:53,8.8.8.8:53"
        "--certificatesresolvers.cloudflare.acme.email=acme@shyim.de"
        "--certificatesresolvers.cloudflare.acme.storage=/data/acme.json"

        # Global Redirect
        "--entrypoints.web.http.redirections.entrypoint.to=websecure"
        "--entrypoints.web.http.redirections.entrypoint.scheme=https"
        "--entrypoints.web.http.redirections.entrypoint.permanent=true"

        "--log.level=INFO"
        "--accesslog=true"
      ];

      ports = [
        "80:80"
        "443:443"
        "443:443/udp"
      ];
    };

    volumes.traefik_data = {};
  };
}