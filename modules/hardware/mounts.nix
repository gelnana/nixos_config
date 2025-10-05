{
  lib,
  config,
  username,
  ...
}: let
  cfg = config.custom.zfs.storage;
in {
  options.custom.zfs.storage = {
    enable = lib.mkEnableOption "Additional ZFS storage pools";

    data = lib.mkEnableOption "Data pool";

    archive = lib.mkEnableOption "Archive pool";
  };

  config = lib.mkIf cfg.enable {
    boot.zfs.extraPools =
      lib.optional cfg.data "data"
      ++ lib.optional cfg.archive "archives";

    fileSystems = lib.mkMerge [
      (lib.mkIf cfg.data {
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

      (lib.mkIf cfg.archive {
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

    systemd.tmpfiles.rules = [
      "L+ /home/${username}/Data - - - - /data/active"
      "L+ /home/${username}/Archives - - - - /archives/media"
    ];
  };
}
