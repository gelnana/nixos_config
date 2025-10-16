{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.custom.programs.games;
in {
  options.custom.programs.games = {
    enable = lib.mkEnableOption "game launchers";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      prismlauncher
      xivlauncher
      heroic
      lutris
      umu-launcher
      nexusmods-app-unfree
      limo
      protontricks
    ];
  };
}
