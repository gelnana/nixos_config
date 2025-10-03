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
        description = "Directories to persist in root filesystem";
      };

      files = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "/etc/machine-id"
        ];
        description = "Files to persist in root filesystem";
      };

      cache = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Directories to persist, but not to snapshot";
      };
    };

    home = {
      directories = lib.mkOption {
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

      files = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          ".bash_history"
          ".zsh_history"
        ];
        description = "Files to persist in home directory";
      };
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

  config = lib.mkIf cfg.tmpfs {
    environment.persistence.${cfg.persistentRoot} = {
      hideMounts = true;

      directories = cfg.root.directories ++ cfg.root.cache;
      files = cfg.root.files;

      users.${username} = {
        directories = cfg.home.directories;
        files = cfg.home.files;
      };
    };

    fileSystems.${cfg.persistentRoot} = {
      neededForBoot = true;
    };

    # Uncomment if you want to use tmpfs as root
    # fileSystems."/" = {
    #   device = "none";
    #   fsType = "tmpfs";
    #   options = [ "defaults" "size=2G" "mode=755" ];
    # };
  };
}
