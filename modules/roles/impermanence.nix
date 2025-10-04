{ lib, config, username, ... }:

let
  cfg = config.custom.persist;
in {
  options.custom.persist = {
    root = {
      directories = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "/etc/nixos"
          "/var/log"
          "/var/lib/bluetooth"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
        ];
      };
      files = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
      };
      cache = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
      };
    };

    home = {
      directories = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        apply = dirs: [
          "Downloads" "Music" "Pictures" "Documents" "Videos" ".config" ".local" ".cache/mozilla" ".mozilla"
        ] ++ dirs;
      };
      files = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          ".bash_history"
          ".zsh_history"
        ];
      };
      cache = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
      };
    };

    tmpfs = lib.mkEnableOption "Use tmpfs for root instead of snapshots" // { default = true; };
  };

  config = {
    boot = {
      tmp.cleanOnBoot = true;
      initrd.postDeviceCommands = lib.mkAfter (
        lib.optionalString (!cfg.tmpfs) "zfs rollback -r zroot/root@blank"
      );
    };

    fileSystems = {
      # use lib.mkIf to avoid setting "/" to null when tmpfs is disabled
      "/" = lib.mkIf cfg.tmpfs (lib.mkForce {
        device = "tmpfs";
        fsType = "tmpfs";
        neededForBoot = true;
        options = [ "defaults" "size=1G" "mode=755" ];
      });

      "/persist" = { neededForBoot = true; };
    };

    security.sudo.extraConfig = "Defaults lecture=never";

    environment.persistence = {
      "/persist" = {
        hideMounts = true;
        files = [ "/etc/machine-id" ] ++ cfg.root.files;
        directories = [ "/var/log" "/var/lib/nixos" ] ++ cfg.root.directories;
        users.${username} = {
          files = cfg.home.files;
          directories = cfg.home.directories;
        };
      };

      "/persist/cache" = {
        hideMounts = true;
        directories = cfg.root.cache;
        users.${username} = {
          directories = cfg.home.cache;
        };
      };
    };
  };
}
