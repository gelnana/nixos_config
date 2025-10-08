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

    minecraft = lib.mkEnableOption "Prism Launcher" // {default = cfg.enable;};
    ffxiv = lib.mkEnableOption "XIVLauncher" // {default = cfg.enable;};
    heroic = lib.mkEnableOption "Heroic launcher" // {default = cfg.enable;};
    parallel = lib.mkEnableOption "Parallel Launcher" // {default = cfg.enable;};
    lutris = lib.mkEnableOption "Lutris" // {default = cfg.enable;};
    modding = lib.mkEnableOption "mod management tools" // {default = cfg.enable;};
    proton = lib.mkEnableOption "Proton utilities" // {default = cfg.enable;};
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      lib.optionals cfg.minecraft [prismlauncher]
      ++ lib.optionals cfg.ffxiv [xivlauncher]
      ++ lib.optionals cfg.heroic [heroic]
      ++ lib.optionals cfg.parallel [parallel-launcher]
      ++ lib.optionals cfg.lutris [lutris umu-launcher]
      ++ lib.optionals cfg.modding [nexusmods-app-unfree limo]
      ++ lib.optionals cfg.proton [protontricks];
  };
}
