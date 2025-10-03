{ config, lib, username, ... }:
let
  cfg = config.custom.persist;
in {
  # NOTE: see zfs.nix for filesystem declarations, filesystem creation is handled via install.sh

  boot = {
    # clear /tmp on boot
    tmp.cleanOnBoot = true;

    # root / home filesystem is destroyed and rebuilt on every boot:
    # https://grahamc.com/blog/erase-your-darlings
    initrd.postDeviceCommands = lib.mkAfter (
      lib.optionalString (!cfg.tmpfs) "zfs rollback -r zroot/root@blank"
    );
  };

  # replace root filesystem with tmpfs
  fileSystems = {
    "/" = lib.mkIf cfg.tmpfs (
      lib.mkForce {
        device = "tmpfs";
        fsType = "tmpfs";
        neededForBoot = true;
        options = [
          "defaults"
          "size=1G"
          "mode=755"
        ];
      }
    );
  };

  security.sudo.extraConfig = "Defaults lecture=never";

  # setup persistence
  environment.persistence = {
    "/persist" = {
      hideMounts = true;
      files = [ "/etc/machine-id" ] ++ cfg.root.files;
      directories = [
        "/var/log"
        "/var/lib/nixos"
      ] ++ cfg.root.directories;

      users.${username} = {
        files = cfg.home.files;
        directories = [
          "pr"
          "nt"
          ".cache/dconf"
          ".config/dconf"
        ] ++ cfg.home.directories;
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
}
