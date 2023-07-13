{ flake
, pkgs
, remapKeys
, lib
, ...
}: {
  imports = [
    ./packages.nix
    ./services.nix
    ./builders.nix
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      builders = @/etc/nix/machines
      log-lines = 30
    '';
    settings.trusted-users = [ "root" "shyim" ];
    nixPath = lib.mkForce [
      "nixpkgs=${flake.inputs.nixpkgs}"
    ];
  };

  environment.shells = [ pkgs.fish ];
  programs.fish.enable = true;

  documentation.enable = false;
  documentation.man.enable = false;
  security.pam.enableSudoTouchIdAuth = true;

  time.timeZone = "Europe/Berlin";
  system.keyboard.enableKeyMapping = true;

  system.keyboard.swapLeftCommandAndLeftAlt = remapKeys;

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

    # Tailscale
    "1475387142"
  ];

  environment.etc."ssh/ssh_config.d/gitpod".text = ''
    Host *.gitpod.io
      ForwardAgent yes
  '';

  environment.etc."ssh/ssh_config.d/timeout".text = ''
    Host *
      ServerAliveInterval 60
  '';
}
