{ flake
, pkgs
, lib
, ...
}: {
  imports = [
    ./packages.nix
    ./services.nix
    ./fonts.nix
  ];

  system.stateVersion = 5;

  programs.bash.enable = true;
  programs.zsh.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixVersions.nix_2_23;
    extraOptions = ''
      experimental-features = nix-command flakes auto-allocate-uids
      builders-use-substitutes = true
      auto-allocate-uids = true
      builders = @/etc/nix/machines
      log-lines = 100
      nix-path = nixpkgs=${flake.inputs.nixpkgs}
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
    settings.trusted-users = [ "root" "shyim" ];
  };

  environment.shells = [ pkgs.fish "/etc/profiles/per-user/shyim/bin/nu" ];
  programs.fish.enable = true;

  documentation.enable = false;
  documentation.man.enable = false;
  security.pam.enableSudoTouchIdAuth = true;

  time.timeZone = "Europe/Berlin";

  system.defaults.finder.ShowPathbar = true;
  system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  system.defaults.NSGlobalDomain = {
    "com.apple.swipescrolldirection" = false;
    "AppleShowAllFiles" = true;
    "AppleShowAllExtensions" = true;
  };

  environment.loginShellInit = "fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin";
}
