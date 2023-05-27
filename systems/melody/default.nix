{ config
, pkgs
, ...
}:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelPackages = pkgs.linuxPackages_testing;

  networking.hostName = "melody";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  documentation.nixos.enable = false;
  documentation.man.enable = false;

  programs.fish.enable = true;
  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver = {
    layout = "us";
    xkbVariant = "altgr-intl";
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.shyim = {
    isNormalUser = true;
    description = "shyim";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.fish;
  };

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "shyim";

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  nixpkgs.config.allowUnfree = true;

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
    wl-clipboard
  ];

  programs.noisetorch.enable = true;
  programs.steam.enable = true;

  programs._1password-gui.enable = true;
  programs._1password-gui.polkitPolicyOwners = [ "shyim" ];
  programs._1password-gui.package = pkgs._1password-gui-beta;
  programs._1password.enable = true;

  security.polkit.enable = true;
  security.sudo.wheelNeedsPassword = false;

  fileSystems.shopware = {
    fsType = "tmpfs";
    mountPoint = "/home/shyim/Code/platform/.devenv/state/mysql";
  };

  boot.supportedFilesystems = [ "ntfs" ];

  fileSystems.games = {
    fsType = "ntfs3";
    device = "/dev/sda1";
    mountPoint = "/mnt/games";
    options = [
      "rw"
      "uid=1000"
      "gid=1000"
    ];
  };

  services.tailscale.enable = true;
  system.stateVersion = "23.05";

  virtualisation.docker.enable = true;
}
