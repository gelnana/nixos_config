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
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      qbittorrent
    ];
  };
}
