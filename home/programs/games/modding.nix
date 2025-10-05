{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.custom.programs.modding;
in {
  options.custom.programs.modding = {
    enable = lib.mkEnableOption "Enable modding tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      limo
      nexusmods-app-unfree
      protontricks
    ];
  };
}
