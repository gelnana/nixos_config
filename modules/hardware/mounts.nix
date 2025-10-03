{ lib, config, ... }:

let
  cfg = config.custom.zfs.storage;
in {
  options.custom.zfs.storage = {
    enable = lib.mkEnableOption "Additional ZFS storage pools";

    nvme2tb = lib.mkEnableOption "Samsung 980 PRO 2TB NVMe (data pool)";

    stsea4tb = lib.mkEnableOption "Seagate 4TB HDD (archives pool)";
  };

  config = lib.mkIf cfg.enable {
    boot.zfs.extraPools =
      lib.optional cfg.nvme2tb "data" ++
      lib.optional cfg.stsea4tb "archives";

    fileSystems = lib.mkMerge [
      (lib.mkIf cfg.nvme2tb {
        "/data/active" = {
          device = "data/active";
          fsType = "zfs";
          neededForBoot = false;
        };
        "/data/projects" = {
          device = "data/projects";
          fsType = "zfs";
          neededForBoot = false;
        };
      })

      (lib.mkIf cfg.stsea4tb {
        "/archives/media" = {
          device = "archives/media";
          fsType = "zfs";
          neededForBoot = false;
        };
        "/archives/backups" = {
          device = "archives/backups";
          fsType = "zfs";
          neededForBoot = false;
        };
      })
    ];

    systemd.tmpfiles.rules =
      lib.optionals cfg.nvme2tb [
        "d /data 0755 root root -"
        "d /data/active 0755 root root -"
        "d /data/projects 0755 root root -"
      ] ++
      lib.optionals cfg.stsea4tb [
        "d /archives 0755 root root -"
        "d /archives/media 0755 root root -"
        "d /archives/backups 0755 root root -"
      ];
  };
}
