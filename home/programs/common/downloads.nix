{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.custom.programs.downloads;
in {
  options.custom.programs.downloads = {
    enable = lib.mkEnableOption "Enable download tools";

    qbittorrent = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install qBittorrent";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      lib.concatLists [
        (
          if cfg.qbittorrent
          then [pkgs.qbittorrent]
          else []
        )
      ];
  };
}
