{ config, lib, pkgs, ... }:
let
  cfg = config.custom.zfs;
  persistCfg = config.custom.persist;
in
{
  boot = {
    supportedFilesystems = [ "zfs" ];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    zfs = {
      devNodes = lib.mkDefault "/dev/disk/by-id";
      package = pkgs.zfs_unstable;
      requestEncryptionCredentials = cfg.encryption;
    };
  };

  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };

  fileSystems = {
    "/boot" = { device = "/dev/disk/by-label/NIXBOOT"; fsType = "vfat"; };
    "/" = { device = "zroot/root"; fsType = "zfs"; neededForBoot = !persistCfg.tmpfs; };
    "/nix" = { device = "zroot/nix"; fsType = "zfs"; };
    "/tmp" = { device = "zroot/tmp"; fsType = "zfs"; };
    "/persist" = { device = "zroot/persist"; fsType = "zfs"; neededForBoot = true; };
    "/persist/cache" = { device = "zroot/cache"; fsType = "zfs"; neededForBoot = true; };
  };

  systemd.services.systemd-udev-settle.enable = false;

  environment.systemPackages = [ pkgs.sanoid ];

  services.sanoid = lib.mkIf cfg.snapshots {
    enable = true;
    interval = "hourly";
    settings = { template_backup = { frequent_period = 15; frequently = 4; hourly_min = 0; daily_hour = 23; daily_min = 59; }; };
    templates.backup = { hourly = 24; daily = 7; weekly = 7; monthly = 3; };
    datasets = { "zroot/persist" = { use_template = [ "backup" ]; hourly = 24; daily = 7; weekly = 7; monthly = 3; }; };
  };
}
