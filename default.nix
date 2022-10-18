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
        ./screego.nix
        ./tailscale.nix
        ./switch.nix
        ./rclone.nix
    ];

    nixpkgs.overlays = import ./overlays;

    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.cleanTmpDir = true;

    time.timeZone = "Europe/Berlin";
    i18n.defaultLocale = "en_US.UTF-8";

    virtualisation.docker.daemon.settings = {
    	fixed-cidr-v6 = "fd00::/80";
  	ipv6 = true;
	live-restore = true;
    };
}
