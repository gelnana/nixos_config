{ lib, config, username, ... }:
let
  cfg = config.custom.syncthing;
in {
  options.custom.syncthing = {
    enable = lib.mkEnableOption "Syncthing file synchronization";

    syncPictures = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Sync Pictures folder";
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      user = username;
      group = "users";
      dataDir = "/home/${username}/Documents";
      configDir = "/home/${username}/.config/syncthing";
      overrideDevices = false;
      overrideFolders = false;
      openDefaultPorts = true;

      settings = {
        devices = {
          "desktop" = { id = "GMVTI4B-DZRE3OZ-DSQS7MI-MAKOQIB-LO37DD7-VQXCZMM-OFVR6NB-6VXY3AH"; };
          "laptop" = { id = "4MXB6CU-FRYORZH-FLGKYOB-NNSINZP-Q2EZ5VC-QIEMVGM-GNPNIRV-LFRQJQH"; };
        };
        folders = lib.mkIf cfg.syncPictures {
          "Pictures" = {
            path = "/home/${username}/Pictures/";
            devices = ["desktop" "laptop"];
          };
        };
      };
    };
  };
}
