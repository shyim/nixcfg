{ lib, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    discord
    google-chrome-dev
    vscode
    spotify
    htop
    yuzu-early-access
    nvtop-amd
    slack
    zoom-us
    lutris
    corectrl
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.hide-activities-button
    gnomeExtensions.gsconnect
    gnomeExtensions.vitals
    liquidctl
    wl-clipboard
  ];

  programs.noisetorch.enable = true;
  programs.steam.enable = true;

  programs._1password-gui.enable = true;
  programs._1password-gui.polkitPolicyOwners = [ "shyim" ];
  programs._1password-gui.package = pkgs._1password-gui-beta;
  programs._1password.enable = true;
}
