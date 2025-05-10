{ config
, pkgs
, ...
}: {
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBuZPgjmIp/dZ0HzRpoFDLsAqFwRGuFBwJiu9qk22tHP"
  ];
}