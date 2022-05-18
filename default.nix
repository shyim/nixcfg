{ config, pkgs, ... }:

{
    imports = [
        ./modules/docker-compose.nix
        ./traefik.nix
        ./packages.nix
        ./services.nix
        ./security.nix
        ./shell.nix
        ./backup.nix
        ./docker
        ./screego.nix
    ];

    nixpkgs.overlays = import ./overlays;

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.cleanTmpDir = true;

    networking.hostName = "aelia";
    networking.domain = "shyim.de";
    time.timeZone = "Europe/Berlin";
    i18n.defaultLocale = "en_US.UTF-8";
}
