{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./traefik.nix
    ./packages.nix
    ./services.nix
    ./security.nix
    ./shell.nix
    ./secrets
  ];

  nixpkgs.overlays = [
    (import ../../pkgs)
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.cleanTmpDir = true;
  zramSwap.enable = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "22.11";
}
