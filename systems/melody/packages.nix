{ lib, pkgs, ... }:

let
  phpstorm = pkgs.jetbrains.phpstorm.overrideAttrs (oldAttrs: {
    src = pkgs.fetchurl {
      url = "https://download-cdn.jetbrains.com/webide/PhpStorm-232.6095.6.tar.gz";
      hash = "sha256-XaptULlp61sRq4Y6td6IJAC52cEOCCJ1Uwr6GS5NLKM=";
    };
  });
in
{
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
    phpstorm
    winetricks
    (pkgs.writeShellScriptBin "pbcopy" ''
      if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
        ${pkgs.wl-clipboard}/bin/wl-copy
      else
        ${pkgs.xclip}/bin/xclip -selection clipboard
      fi
    '')
  ];

  programs.steam.enable = true;

  programs._1password-gui.enable = true;
  programs._1password-gui.polkitPolicyOwners = [ "shyim" ];
  programs._1password-gui.package = pkgs._1password-gui-beta;
  programs._1password.enable = true;
}
