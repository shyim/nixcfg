{ config
, pkgs
, ...
}:

let
  discordCustom = pkgs.discord-ptb.override {
    version = "0.0.39";
    src = pkgs.fetchurl {
      url = "https://dl-ptb.discordapp.net/apps/linux/0.0.39/discord-ptb-0.0.39.tar.gz";
      sha256 = "LoDg3iwK18rDszU/dQEK0/J8DIxrqydsfflZo8IARks=";
    };
  };
in
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
  boot.kernelPackages = pkgs.linuxPackages_latest;

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
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "shyim";

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    discordCustom
    google-chrome-dev
    vscode
    spotify
    htop
    kitty
    jetbrains.goland
    nvtop-amd
    slack
    zoom-us
  ];

  programs.steam.enable = true;

  programs._1password-gui.enable = true;
  programs._1password-gui.polkitPolicyOwners = [ "shyim" ];
  programs._1password-gui.package = pkgs._1password-gui-beta;
  programs._1password.enable = true;

  security.polkit.enable = true;
  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "23.05";
}
