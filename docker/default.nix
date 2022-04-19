{ config, pkgs, ... }:

{
    imports = [
        ./hedgedoc.nix
        ./gamercard.nix
        ./wakapi.nix
        ./n8n.nix
        ./switch.nix
    ];
}