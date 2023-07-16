{ config
, pkgs
, ...
}: {
  imports = [
    ./backup.nix
    ./rclone.nix
    ./screego.nix
    ./switch.nix
    ./tailscale.nix
    ./thelounge.nix
    ./wakapi.nix
    ./paperless.nix
    ./matrix.nix
  ];
}
