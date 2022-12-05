{ config, lib, pkgs, modulesPath, ... }:

{
  services.traefik.enable = true;
  services.traefik.group = "docker";
  services.traefik.staticConfigOptions = {
    api.dashboard = true;
    api.insecure = true;
    pilot.dashboard = false;
    experimental.http3 = true;
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
        resolvers = [ "1.1.1.1:53" "1.0.0.1:53" ];
      };
    };
  };

  services.traefik.dynamicConfigOptions = {
    http.middlewares = {
      compress.compress = { };
    };

    http.middlewares = {
      web-redirect.redirectScheme.scheme = "https";
    };
    tls.options.default = {
      minVersion = "VersionTLS12";
      cipherSuites = [
        "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"
        "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
        "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384"
        "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"
        "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305"
        "TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305"
      ];
    };
  };
}
