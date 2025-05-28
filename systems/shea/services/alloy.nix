{ config, ... }: {
  sops.secrets = {
    grafanaAlloy = {
    };
  };

  services.alloy = {
    enable = true;
  };

  environment.etc."alloy/config.alloy" = {
    source = ./config.alloy;
  };

  systemd.services.alloy.serviceConfig.EnvironmentFile = [
    config.sops.secrets.grafanaAlloy.path
  ];
  systemd.services.alloy.serviceConfig.SupplementaryGroups = [
    "systemd-journal"
    "docker"
  ];
}