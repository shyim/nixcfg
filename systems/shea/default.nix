{ config, pkgs, ... }:

{
  imports = [
    ./modules/docker-compose.nix
    ./hardware-configuration.nix
    ./services.nix
    ./security.nix
    ./networking.nix
    ./packages.nix
    ./shell.nix
    ./tailscale.nix
    ./traefik.nix
    ./screego.nix
    ./switch.nix
    ./secrets
  ];

  nixpkgs.overlays = [
    (import ../../pkgs)
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.cleanTmpDir = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "23.05";
}
