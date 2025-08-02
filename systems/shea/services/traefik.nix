{ config, ... }:
{
  sops.secrets.traefik = { };

  services.docker-compose.traefik.config = {
    services = {
      pangolin = {
        image = "docker.io/fosrl/pangolin:1.8.0";
        restart = "unless-stopped";
        volumes = [
          "/var/lib/pangolin:/app/config"
        ];
        healthcheck = {
          test = ["CMD" "curl" "-f" "http://localhost:3001/api/v1/"];
          interval = "30s";
          timeout = "10s";
          start_interval = "3s";
          start_period = "30s";
          retries = 3;
        };
      };
      gerbil = {
        image = "docker.io/fosrl/gerbil:1.1.0";
        restart = "unless-stopped";
        depends_on.pangolin.condition = "service_healthy";
        command = [
          "--reachableAt=http://gerbil:3003"
          "--generateAndSaveKeyTo=/var/config/key"
          "--remoteConfig=http://pangolin:3001/api/v1/gerbil/get-config"
          "--reportBandwidthTo=http://pangolin:3001/api/v1/gerbil/receive-bandwidth"
        ];
        volumes = [
          "/var/lib/pangolin:/var/config"
        ];
        cap_add = [
          "NET_ADMIN"
          "SYS_MODULE"
        ];
        ports = [
          "51820:51820/udp"
          "21820:21820/udp"
          "80:80"
          "443:443"
          "443:443/udp"
        ];
      };

      traefik = {
        image = "traefik";
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
          "traefik_data:/data"

          "/var/lib/pangolin/traefik:/etc/traefik:ro"
        ];
        env_file = config.sops.secrets.traefik.path;

        depends_on.pangolin.condition = "service_healthy";
        network_mode = "service:gerbil";

        command = [
          "--configFile=/etc/traefik/traefik_config.yml"

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
      };
    };

    volumes.traefik_data = { };
  };
}
