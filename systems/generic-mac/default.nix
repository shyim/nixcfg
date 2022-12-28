{ pkgs, ... }: {
  imports = [
    ./packages.nix
    ./services.nix
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nixpkgs.config.allowUnfree = true;
  nix.package = pkgs.nix;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.settings.trusted-users = [ "root" "shyim" ];

  environment.shells = [ pkgs.fish ];
  programs.fish.enable = true;

  documentation.enable = false;
  documentation.man.enable = false;
  security.pam.enableSudoTouchIdAuth = true;

  time.timeZone = "Europe/Berlin";
  system.keyboard.enableKeyMapping = true;
  system.keyboard.swapLeftCommandAndLeftAlt = true;
  system.defaults.finder.ShowPathbar = true;
  system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  system.defaults.NSGlobalDomain = {
    "com.apple.swipescrolldirection" = false;
    "AppleShowAllFiles" = true;
    "AppleShowAllExtensions" = true;
  };

  environment.loginShellInit = "fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin";

  mas.apps = [
    # iStat Menus
    "1319778037"

    # The unarchiver
    "425424353"

    # Slack
    "803453959"

    # Tailscale
    "1475387142"

    # Wireguard
    "1451685025"
  ];
}
