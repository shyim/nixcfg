{ config, pkgs, ... }:

{
  services.openssh.enable = true;

  virtualisation.docker.enable = true;

  virtualisation.docker.daemon.settings = {
    fixed-cidr-v6 = "fd00::/80";
    ipv6 = true;
    live-restore = true;
  };
}
