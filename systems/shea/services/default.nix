{ config
, pkgs
, ...
}: {
  imports = [
    ./screego.nix
    ./switch.nix
    ./thelounge.nix
    ./wakapi.nix
  ];
}
