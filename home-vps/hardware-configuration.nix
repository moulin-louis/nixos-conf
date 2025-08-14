{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/20d0e88f-d7e1-4ea1-9dc9-671e42dadc26";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7AF5-BAC7";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };
  fileSystems."/media/EHDD" = {
    device = "/dev/disk/by-uuid/a83b15e4-e8af-4ca2-b6e3-aedb40676a76";
    fsType = "ext4";
    options = [
      "defaults"
      "rw"
    ];
  };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
