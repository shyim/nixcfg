{ config
, pkgs
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./security.nix
    ./shell.nix
    ./services
  ];

  boot.loader.systemd-boot.configurationLimit = 5;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.cleanTmpDir = true;

  networking = {
    hostName = "shea";
    domain = "shyim.de";
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "23.05";

  sops.defaultSopsFile = ./sops/default.yaml;
  virtualisation.podman.enable = true;

  environment.etc."resolv.conf".text = ''
    domain shyim.de
    search shyim.de shea.shyim.de
    nameserver 1.1.1.1
    nameserver 8.8.8.8
    options edns0
  '';
}
