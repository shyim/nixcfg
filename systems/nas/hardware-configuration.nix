{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/minimal.nix") ];
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4BCB-B11B";
    fsType = "vfat";
  };
  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "xen_blkfront"
    "vmw_pvscsi"
  ];
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e98f2914-a904-4b7f-820a-28d08e42dc4a";
    fsType = "ext4";
  };
  swapDevices = [ { device = "/dev/disk/by-uuid/516d1b59-9be8-4ec7-ac39-d88a1e843c38"; } ];
}
