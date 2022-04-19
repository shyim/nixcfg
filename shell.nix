{ config, pkgs, ... }:

{
    users.defaultUserShell = pkgs.fish;
    environment.shellAliases = {
        nano = "nvim";
        vi = "nvim";
        vim = "nvim";
    };
}