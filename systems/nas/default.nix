{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./smb.nix
    ./prom.nix
    ./adguard.nix
  ];

  sops.defaultSopsFile = ./sops/default.yaml;

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = false;
  networking.hostName = "snorlax";
  networking.domain = "shyim.de";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [ ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBuZPgjmIp/dZ0HzRpoFDLsAqFwRGuFBwJiu9qk22tHP'' ];
  system.stateVersion = "24.11";
  services.tailscale.enable = true;
  systemd.network.enable = true;
  networking.useDHCP = false;

  systemd.network.networks."10-lan" = {
    matchConfig.Name = "enp2s0";
    networkConfig.DHCP = "yes";
  };

  networking.hostId = "8c12a855";
  boot.supportedFilesystems = [ "zfs" ];

  environment.systemPackages = with pkgs; [
    htop
  ];
}
