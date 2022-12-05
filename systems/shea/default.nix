{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./services.nix
    ./security.nix
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
