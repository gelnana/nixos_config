{ lib, config, pkgs, ... }:
let
  cfg = config.custom.programs.games.launchers;
in {
  options.custom.programs.games.launchers = {
    enable = lib.mkEnableOption "game launchers";

    ffxiv = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable XIVLauncher for Final Fantasy XIV";
    };

    minecraft = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable PrismLauncher for Minecraft";
    };

    n64 = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Parallel Launcher for N64 emulation";
    };

    lutris = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Lutris game manager";
    };

    heroic = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Heroic Games Launcher (Epic/GOG)";
    };

    umu = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable UMU Launcher (universal compatibility layer)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      lib.optional cfg.ffxiv xivlauncher
      ++ lib.optional cfg.minecraft prismlauncher
      ++ lib.optional cfg.n64 parallel-launcher
      ++ lib.optional cfg.lutris lutris
      ++ lib.optional cfg.heroic heroic
      ++ lib.optional cfg.umu umu-launcher;
  };
}
