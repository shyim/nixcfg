{ config, pkgs, ... }:

{
    users.defaultUserShell = pkgs.fish;

    environment.systemPackages = with pkgs; [
        bat
        lsd
    ];

    environment = {
        variables = {
            EDITOR = "nvim";
        };

        shellAliases = {
            nano = "nvim";
            vi = "nvim";
            vim = "nvim";
            cat = "bat";
            ls = "lsd";
        };
    };

    programs.fish = {
        enable = true;
    };
}