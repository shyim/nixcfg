{
  config,
  pkgs,
  flake,
  ...
}:
{
  imports = [
    ../../modules/docker-compose.nix
    ./hardware-configuration.nix
    ./services.nix
    ./security.nix
    ./packages.nix
    ./ssh.nix
  ];

  sops.defaultSopsFile = ./sops/default.yaml;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.tmp.cleanOnBoot = true;

  virtualisation.docker = {
    enable = true;
    liveRestore = true;
    autoPrune.enable = true;
  };

  nix.gc.automatic = true;

  networking = {
    hostName = "shea";
    domain = "shyim.de";
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "24.11";
}
