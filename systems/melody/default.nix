{ config
, pkgs
, ...
}:

{
  imports =
    [
      ./hardware-configuration.nix
      ./packages.nix
      ./services.nix
      ./warp.nix
    ];

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes repl-flake auto-allocate-uids
  '';

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "ntfs" ];

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

  users.users.shyim = {
    isNormalUser = true;
    description = "shyim";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.fish;
  };

  fileSystems.shopware = {
    fsType = "tmpfs";
    mountPoint = "/home/shyim/Code/platform/.devenv/state/mysql";
  };

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

  system.stateVersion = "23.05";
}
