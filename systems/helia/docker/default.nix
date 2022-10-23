{ config, pkgs, ... }:

{
  imports = [
    ./gamercard.nix
    ./wakapi.nix
    ./n8n.nix
    ./switch.nix
    ./qodana.nix
    ./thelounge.nix
  ];
}
