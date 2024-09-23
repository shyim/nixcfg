{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/headless.nix") ];
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
  fileSystems."/boot" = { device = "/dev/disk/by-uuid/4BCB-B11B"; fsType = "vfat"; };
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "/dev/nvme1n1p2"; fsType = "ext4"; };
  swapDevices = [{ device = "/dev/nvme1n1p3"; }];
}
