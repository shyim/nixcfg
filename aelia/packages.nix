{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        htop
        neovim
        git
        psmisc # killall
        unzip
        tmux
	    rclone 
    ];
}
