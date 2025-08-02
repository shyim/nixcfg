{ lib, config, ... }:
{
  sops.secrets = {
    grafanaCloud = { };
  };

  services.alloy = {
    enable = true;
    configPath = ./config.alloy;
  };

  systemd.services.alloy.serviceConfig.DynamicUser = lib.mkForce false;
  systemd.services.alloy.serviceConfig.User = "root";
  systemd.services.alloy.serviceConfig.EnvironmentFile = config.sops.secrets.grafanaCloud.path;
}
