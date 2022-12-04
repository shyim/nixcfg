{ config, pkgs, ... }:

{
  imports = [
    ./wakapi.nix
    ./n8n.nix
    ./switch.nix
    ./thelounge.nix
  ];
}
