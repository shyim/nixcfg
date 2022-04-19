{ config, pkgs, ... }:

{
    imports = [
        ./modules/docker-compose.nix
        ./traefik.nix
        ./packages.nix
        ./services.nix
        ./security.nix
        ./shell.nix
        ./docker
    ];

    networking.hostName = "aelia";
    time.timeZone = "Europe/Berlin";
    i18n.defaultLocale = "en_US.UTF-8";
}