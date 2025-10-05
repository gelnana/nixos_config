{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.custom.programs.game-launchers;
in {
  options.custom.programs.game-launchers = {
    enable = lib.mkEnableOption "Enable all game launchers";
  };

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
