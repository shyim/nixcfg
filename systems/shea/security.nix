{ config
, pkgs
, ...
}: {
  # Is managed in Oracle Security List
  networking.firewall.enable = false;

  users.users.root.openssh.authorizedKeys.keys = [
    # Nix Builder
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIE+0y1Z/taJj1sQPYErWmXx2dt7Ol/b8zLVNcCvNw9a"

    # GitHub Action
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEkbGqwlPvIaMBd5UV1disj1GtPm0eQsvx9mOdRBbNis"

    # Own
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBuZPgjmIp/dZ0HzRpoFDLsAqFwRGuFBwJiu9qk22tHP"
  ];
}
