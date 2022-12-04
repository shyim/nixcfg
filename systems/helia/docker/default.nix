{ config, pkgs, ... }:

{
  imports = [
    ./gamercard.nix
    ./wakapi.nix
    ./n8n.nix
    ./switch.nix
    ./thelounge.nix
  ];
}
