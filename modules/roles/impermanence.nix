{ lib, config, username, ... }:

let
  cfg = config.custom.persist;
in {
  options.custom.persist = {
    root.directories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "/etc/nixos"
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
      ];
      description = "Directories to persist in root filesystem";
    };

    root.files = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "/etc/machine-id" ];
      description = "Files to persist in root filesystem";
    };

    root.cache = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "System cache directories to persist (separate dataset)";
    };

    home.directories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "Videos"
        ".nixos"
        ".ssh"
        ".config"
        ".local"
        ".mozilla"
      ];
      description = "Directories to persist in home directory";
    };

    home.files = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        ".bash_history"
        ".zsh_history"
      ];
      description = "Files to persist in home directory";
    };

    # optional: if you want separate home caches
    home.cache = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Cache directories in home that persist separately";
    };

    tmpfs = lib.mkEnableOption "Use tmpfs for root instead of snapshots" // {
      default = true;
    };

    persistentRoot = lib.mkOption {
      type = lib.types.str;
      default = "/persist";
      description = "Path to persistent storage root";
    };
  };

  config = {
    boot = {
      tmp.cleanOnBoot = true;

      initrd.postDeviceCommands = lib.mkAfter (
        lib.optionalString (!cfg.tmpfs) "zfs rollback -r zroot/root@blank"
      );
    };

    fileSystems = {
      "/" = lib.mkIf cfg.tmpfs (
        lib.mkForce {
          device = "tmpfs";
          fsType = "tmpfs";
          neededForBoot = true;
          options = [ "defaults" "size=1G" "mode=755" ];
        }
      );

      ${cfg.persistentRoot} = {
        neededForBoot = true;
      };
    };

    security.sudo.extraConfig = "Defaults lecture=never";

    environment.persistence = {
      "${cfg.persistentRoot}" = {
        hideMounts = true;
        files       = lib.unique cfg.root.files;
        directories = lib.unique cfg.root.directories;

        users.${username} = {
          files       = lib.unique cfg.home.files;
          directories = lib.unique cfg.home.directories;
        };
      };

      "${cfg.persistentRoot}/cache" = {
        hideMounts = true;
        directories = lib.unique cfg.root.cache;

        users.${username} = {
          directories = lib.unique cfg.home.cache;
        };
      };
    };
  };
}
