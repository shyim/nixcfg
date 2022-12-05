{ config, pkgs, ... }:

{
  services.openssh.enable = true;

  virtualisation.docker.enable = true;

  virtualisation.docker.daemon.settings = {
    live-restore = true;
  };
}
