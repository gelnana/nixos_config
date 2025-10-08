{
  lib,
  config,
  username,
  ...
}: let
  cfg = config.custom.zfs.storage;
in {
  options.custom.zfs.storage = {
    enable = lib.mkEnableOption "ZFS storage pools";
    data = lib.mkEnableOption "data pool";
    archive = lib.mkEnableOption "archives pool";
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
        };
        "/data/active/documents" = {
          device = "data/active/documents";
          fsType = "zfs";
        };
        "/data/active/work" = {
          device = "data/active/work";
          fsType = "zfs";
        };

        "/data/media" = {
          device = "data/media";
          fsType = "zfs";
        };
        "/data/media/pictures" = {
          device = "data/media/pictures";
          fsType = "zfs";
        };
        "/data/media/video" = {
          device = "data/media/video";
          fsType = "zfs";
        };
        "/data/media/games" = {
          device = "data/media/games";
          fsType = "zfs";
        };
        "/data/media/music" = {
          device = "data/media/music";
          fsType = "zfs";
        };

        "/data/archive" = {
          device = "data/archive";
          fsType = "zfs";
        };
      })

      (lib.mkIf cfg.archive {
        "/archives/media" = {
          device = "archives/media";
          fsType = "zfs";
        };
        "/archives/backups" = {
          device = "archives/backups";
          fsType = "zfs";
        };
      })
    ];

    services.sanoid = {
      enable = true;
      datasets = lib.mkMerge [
        (lib.mkIf cfg.data {
          "data/active" = {
            autosnap = true;
            autoprune = true;
            hourly = 24;
            daily = 7;
            weekly = 4;
            monthly = 6;
            recursive = true;
          };

          "data/media" = {
            autosnap = true;
            autoprune = true;
            daily = 7;
            weekly = 4;
            monthly = 12;
            recursive = true;
          };

          "data/archive" = {
            autosnap = true;
            autoprune = true;
            weekly = 4;
            monthly = 12;
            yearly = 3;
          };
        })

        (lib.mkIf cfg.archive {
          "archives/backups" = {
            autosnap = true;
            autoprune = true;
            daily = 7;
            weekly = 4;
            monthly = 12;
          };
        })
      ];
    };

    systemd.tmpfiles.rules =
      lib.optionals cfg.data [
        "d /data/active/documents 0755 ${username} users -"
        "d /data/active/projects 0755 ${username} users -"
        "d /data/active/work 0755 ${username} users -"
        "d /data/media/pictures 0755 ${username} users -"
        "d /data/media/video 0755 ${username} users -"
        "d /data/media/games 0755 ${username} users -"
        "d /data/media/music 0755 ${username} users -"

        "d /data/media/pictures/Screenshots 0755 ${username} users -"

        "L+ /home/${username}/Documents - - - - /data/active/documents"
        "L+ /home/${username}/Projects - - - - /data/projects"
        "L+ /home/${username}/Work - - - - /data/active/work"

        # Media
        "L+ /home/${username}/Pictures - - - - /data/media/pictures"
        "L+ /home/${username}/Videos - - - - /data/media/video"
        "L+ /home/${username}/Games - - - - /data/media/games"
        "L+ /home/${username}/Music - - - - /data/media/music"
      ]
      ++ lib.optionals cfg.archive [
        "d /archives/media 0755 ${username} users -"
        "L+ /home/${username}/Archives - - - - /archives/media"
      ];
  };
}
