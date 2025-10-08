{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.custom.programs.games;
in {
  options.custom.programs.games = lib.mkEnableOption "Enable all game launchers";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      prismlauncher
      xivlauncher
      heroic
      parallel-launcher
      lutris
      umu-launcher
      nexusmods-app-unfree
      limo
      protontricks
    ];
  };
}
