{ config, pkgs, ... }:

{
    imports = [
        ./hedgedoc.nix
        ./gamercard.nix
        ./wakapi.nix
        ./n8n.nix
        ./switch.nix
        ./wireguard.nix
        ./tanoshi.nix
        ./qodana.nix
    ];
}