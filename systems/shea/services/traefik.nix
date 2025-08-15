{ config, ... }:
{
  sops.secrets.traefik = { };

  services.traefik = {
    enable = true;

    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          asDefault = true;
          http.redirections.entrypoint = {
            to = "websecure";
            scheme = "https";
          };
        };

        websecure = {
          address = ":443";
          asDefault = true;
          http.tls.certResolver = "letsencrypt";
        };
      };

      log = {
        level = "INFO";
        filePath = "${config.services.traefik.dataDir}/traefik.log";
        format = "json";
      };

      certificatesResolvers.letsencrypt.acme = {
        email = "postmaster@YOUR.DOMAIN";
        storage = "${config.services.traefik.dataDir}/acme.json";
        httpChallenge.entryPoint = "web";
      };

      api.dashboard = true;
      # Access the Traefik dashboard on <Traefik IP>:8080 of your server
      # api.insecure = true;
    };

    dynamicConfigOptions = {
      http.routers = {};
      http.services = {};
    };
  };

  services.docker-compose.traefik.config = {
    services = {
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

          "--log.level=INFO"
          "--accesslog=true"
        ];
      };
    };

    volumes.traefik_data = { };
  };
}
