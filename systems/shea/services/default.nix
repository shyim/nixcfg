{ config
, pkgs
, ...
}: {
  imports = [
    ./backup.nix
    ./screego.nix
    ./switch.nix
    ./thelounge.nix
    ./wakapi.nix
    ./mediamtx.nix
  ];
}
