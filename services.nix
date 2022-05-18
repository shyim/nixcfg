{ config, pkgs, ... }:

{
    services.openssh.enable = true;
#    services.openssh.extraConfig = "PubkeyAcceptedAlgorithms +ssh-rsa";

    virtualisation.docker.enable = true;
}
