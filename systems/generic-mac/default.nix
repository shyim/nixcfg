{ flake, pkgs, remapKeys, lib, ... }: {
  imports = [
    ./packages.nix
    ./services.nix
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nixpkgs.config.allowUnfree = true;
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    builders = @/etc/nix/machines
  '';
  nix.settings.trusted-users = [ "root" "shyim" ];
  nix.nixPath = lib.mkForce [
    "nixpkgs=${flake.inputs.nixpkgs}"
  ];

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

  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "shea.bunny-chickadee.ts.net";
      maxJobs = 10;
      sshKey = "/Users/shyim/.ssh/nix";
      sshUser = "root";
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      system = "aarch64-linux";
    }
    {
      hostName = "138.201.121.30";
      maxJobs = 10;
      sshKey = "/Users/shyim/.ssh/nix";
      sshUser = "root";
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      system = "x86_64-linux";
    }
    {
      hostName = "88.99.6.33";
      maxJobs = 10;
      sshKey = "/Users/shyim/.ssh/nix";
      sshUser = "root";
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" "system" "features" ];
      system = "x86_64-linux";
    }
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
