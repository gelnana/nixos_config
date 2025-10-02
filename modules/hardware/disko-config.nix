{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.disko;
in
{
  options.custom.disko = {
    device = lib.mkOption {
      type = lib.types.str;
      description = "Primary disk device path";
      example = "/dev/nvme0n1";
    };

    bootSize = lib.mkOption {
      type = lib.types.str;
      default = "1G";
      description = "Size of the boot partition";
    };

    useZfs = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use ZFS with snapshots instead of btrfs";
    };
  };

  config = lib.mkIf (cfg.device != null) {
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = cfg.device;
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = cfg.bootSize;
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };

              primary = lib.mkMerge [
                {
                  size = "100%";
                }

                # ZFS
                (lib.mkIf cfg.useZfs {
                  content = {
                    type = "zfs";
                    pool = "zroot";
                  };
                })

                # Btrfs
                (lib.mkIf (!cfg.useZfs) {
                  content = {
                    type = "btrfs";
                    extraArgs = [ "-f" ];
                    subvolumes = {
                      "/nix" = {
                        mountpoint = "/nix";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                      "/persist" = {
                        mountpoint = "/persist";
                        mountOptions = [ "compress=zstd" ];
                      };
                      "/persist/cache" = {
                        mountpoint = "/persist/cache";
                        mountOptions = [ "compress=zstd" "noatime" ];
                      };
                    };
                  };
                })
              ];
            };
          };
        };
      };

      # ZFS pool configuration (only if using ZFS)
      zpool = lib.mkIf cfg.useZfs {
        zroot = {
          type = "zpool";
          rootFsOptions = {
            compression = "zstd";
            acltype = "posixacl";
            xattr = "sa";
            atime = "off";
            "com.sun:auto-snapshot" = "false";
          };

          postCreateHook = ''
            zfs snapshot zroot/root@blank
          '';

          datasets = {
            root = {
              type = "zfs_fs";
              mountpoint = "/";
              options.mountpoint = "legacy";
              postCreateHook = ''
                zfs snapshot zroot/root@blank
              '';
            };

            nix = {
              type = "zfs_fs";
              mountpoint = "/nix";
              options = {
                atime = "off";
                canmount = "on";
                mountpoint = "legacy";
              };
            };

            persist = {
              type = "zfs_fs";
              mountpoint = "/persist";
              options = {
                canmount = "on";
                mountpoint = "legacy";
              };
            };

            "persist/cache" = {
              type = "zfs_fs";
              mountpoint = "/persist/cache";
              options = {
                canmount = "on";
                mountpoint = "legacy";
                "com.sun:auto-snapshot" = "false";
              };
            };
          };
        };
      };
    };

    fileSystems = {
      "/nix".neededForBoot = true;
      "/persist".neededForBoot = true;
      "/persist/cache".neededForBoot = true;
    };

    # Enable ZFS support if using ZFS
    boot.supportedFilesystems = lib.mkIf cfg.useZfs [ "zfs" ];

    # ZFS requires a unique hostId
    networking.hostId = lib.mkIf cfg.useZfs (
      lib.mkDefault (builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName))
    );
  };
}
