{ config
, pkgs
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./security.nix
    ./shell.nix
    ./secrets
    ./services
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.cleanTmpDir = true;

  networking = {
    hostName = "shea";
    domain = "shyim.de";
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "23.05";
  
  virtualisation.docker.enable = true;
}
