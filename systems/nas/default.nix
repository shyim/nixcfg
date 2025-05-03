{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./cloudflare.nix
    ./smb.nix
    ./webserver.nix
  ];

  sops.defaultSopsFile = ./sops/default.yaml;

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = false;
  networking.hostName = "snorlax";
  networking.domain = "shyim.de";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [ ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBuZPgjmIp/dZ0HzRpoFDLsAqFwRGuFBwJiu9qk22tHP'' ];
  system.stateVersion = "24.11";
  systemd.network.enable = true;
  networking.useDHCP = false;
  virtualisation.docker.enable = true;

  systemd.network.networks."10-lan" = {
    matchConfig.Name = "enp3s0";
    networkConfig.DHCP = "yes";
  };

  hardware.bluetooth.enable = true;

  networking.hostId = "8c12a855";
  boot.supportedFilesystems = [ "zfs" ];

  environment.systemPackages = with pkgs; [
    htop
  ];

  services.zfs.autoScrub.enable = true;
  boot.zfs.extraPools = [ "nvme" "storage" ];

  services.vnstat.enable = true;

  services.adguardhome = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
