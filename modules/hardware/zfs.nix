{
  config,
  lib,
  pkgs,
  ...
}: {
  #######################
  # Boot / Kernel / ZFS #
  #######################
  boot = {
    supportedFilesystems = ["zfs"];
    kernelPackages = pkgs.linuxPackages_zen;
    zfs = {
      devNodes = lib.mkDefault "/dev/disk/by-id";
      package = pkgs.zfs_unstable;
      requestEncryptionCredentials = false;
    };
  };

  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };

  fileSystems = {
    "/" = {
      device = "zroot/root";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };
    "/nix" = {
      device = "zroot/nix";
      fsType = "zfs";
    };
    "/tmp" = {fsType = "tmpfs";};
  };

  environment.systemPackages = [
    pkgs.sanoid
    pkgs.syncoid
  ];

  systemd.services.systemd-udev-settle.enable = true;
}
