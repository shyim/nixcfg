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

  programs.bash.enable = true;
  programs.zsh.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixUnstable;
    settings.substituters = [
      "https://shopware.cachix.org"
      "https://shyim.cachix.org"
      "https://devenv.cachix.org"
    ];
    settings.trusted-public-keys = [
      "shopware.cachix.org-1:IDifwLVQaaDU2qhlPkJsWJp/Pq0PfzHPIB90hBOhL3k="
      "shyim.cachix.org-1:ZazuDAWm/q5YbFVmuJCTYbnopdR1NqI2Hl8IgZ1jYIM="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
    extraOptions = ''
      experimental-features = nix-command flakes auto-allocate-uids repl-flake
      auto-allocate-uids = true
      builders-use-substitutes = true
      builders = @/etc/nix/machines
      log-lines = 100
      nix-path = nixpkgs=${flake.inputs.nixpkgs}
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
    settings.trusted-users = [ "root" "shyim" ];
  };

  environment.shells = [ pkgs.fish ];
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

  mas.apps = [
    # iStat Menus
    "1319778037"
  ];
}
