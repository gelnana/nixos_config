{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.custom.programs.organization;
in {
  options.custom.programs.organization = {
    enable = lib.mkEnableOption "Enable organization tools";

    calibre = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install Calibre";
    };

    zotero_7 = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install Zotero 7";
    };

    qnotero = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install Qnotero";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      lib.concatLists [
        (
          if cfg.calibre
          then [pkgs.calibre]
          else []
        )
        (
          if cfg.zotero_7
          then [pkgs.zotero_7]
          else []
        )
        (
          if cfg.qnotero
          then [pkgs.qnotero]
          else []
        )
      ];
  };
}
