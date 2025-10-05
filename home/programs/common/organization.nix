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
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      calibre
      zotero_7
      qnotero
    ];
  };
}
