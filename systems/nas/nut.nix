{ ... }: {
  sops.secrets.ghcrPassword = { };

  virtualisation.oci-containers.containers.nut = {
    image = "ghcr.io/shyim/nut";
    volumes = [
      "/mnt/switch:/volume1/switch"
    ];
    cmd = [ "server" ];
    workdir = "/volume1/switch";
    ports = [ "127.0.0.1:9000:9000" ];
    login = {
      registry = "ghcr.io";
      username = "shyim";
      passwordFile = "/run/secrets/ghcrPassword";
    };
  };
}
