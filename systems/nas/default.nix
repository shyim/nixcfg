{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./smb.nix
    ./webserver.nix
    ./adguard.nix
  ];

  sops.defaultSopsFile = ./sops/default.yaml;

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = false;
  networking.hostName = "snorlax";
  networking.domain = "shyim.de";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBuZPgjmIp/dZ0HzRpoFDLsAqFwRGuFBwJiu9qk22tHP''
  ];
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
    smartmontools
  ];

  services.zfs.autoScrub.enable = true;
  boot.zfs.extraPools = [
    "nvme"
    "snorlax"
  ];

  services.vnstat.enable = true;
  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "both";
  services.tailscale.openFirewall = true;
  services.resolved.enable = true;

  services.networkd-dispatcher = {
    enable = true;
    rules."50-tailscale" = {
      onState = [ "routable" ];
      script = ''
        #!${pkgs.runtimeShell}
        ${pkgs.ethtool}/bin/ethtool -K enp3s0 rx-udp-gro-forwarding on rx-gro-list off
      '';
    };
  };

  boot.kernelParams = [
    "i915.enable_guc=2"
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime
    ];
  };

  services.smartd = {
    enable = true;
    devices = [
      {
        device = "/dev/disk/by-id/ata-ST14000NM001G-2KJ103_ZL201L70";
      }
      {
        device = "/dev/disk/by-id/ata-ST14000NM001G-2KJ103_ZL2D6VB6";
      }
    ];
  };
}
