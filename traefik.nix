{ config, lib, pkgs, modulesPath, ... }:

{
  services.traefik.enable = true;
  services.traefik.group = "docker";
  services.traefik.staticConfigOptions = {
    api.dashboard = true;
    api.insecure = true;
    pilot.dashboard = false;
    entryPoints = {
      web = {
        address = ":80";
      };
      websecure = {
        address = ":443";
      };
    };
    providers.docker = {
      endpoint = "unix:///var/run/docker.sock";
      exposedByDefault = false;
    };

    certificatesResolvers.cf.acme = {
      email = "traefik@shyim.de";
      storage = "/srv/traefik/acme.json";
      dnsChallenge = {
        provider = "cloudflare";
        resolvers = ["1.1.1.1:53" "1.0.0.1:53"];
      };
    };
  };

  services.traefik.dynamicConfigOptions = {
    http.middlewares = {
      compress.compress = {};
    };

    http.middlewares = {
      web-redirect.redirectScheme.scheme = "https";
    };
  };

  systemd.services.traefik.serviceConfig.EnvironmentFile = "/srv/traefik/.env";
}
