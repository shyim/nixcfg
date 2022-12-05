{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  users.users.root.openssh.authorizedKeys.keys = [
    # GitHub Action
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEkbGqwlPvIaMBd5UV1disj1GtPm0eQsvx9mOdRBbNis"

    # Own
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBuZPgjmIp/dZ0HzRpoFDLsAqFwRGuFBwJiu9qk22tHP"
  ];
}