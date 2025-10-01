{ lib, pkgs, config, ... }:
let 
  cfg = cfg.custom.programs.game-launchers;
in 
{
  options.custom.programs.game-launchers = {
      enable = lib.mkEnableOption "Enable all game launchers";
      
      minecraft = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "";
        };

      xiv = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "";
        };

      heroic = lib.mkOption {
          type = lib.types.bool;
          default = true;
          decription = "";
        };

      parallel = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "";
        };

      lutris = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "";
        };

      umu = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "";        
        };

      nexus = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "";
        };

      limo = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "";         
        };

      proton = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "";        
        };
    };

    config = lib.mkIf cfg.enable {
    home.packages = with pkgs; lib.concatLists [
      (if cfg.minecraft then [ pkgs.prismlauncher ] else [])
      (if cfg.xiv then [ pkgs.xivlauncher ] else [])
      (if cfg.heroic then [ pkgs.heroic ] else [])
      (if cfg.parallel then [ pkgs.parallel-launcher ] else [])
      (if cfg.lutris then [ pkgs.umu-launcher ] else [])
      (if cfg.umu then [ pkgs.umu-launcher ] else [])
      (if cfg.nexus then [ pkgs.nexusmods-app-unfree ] else [])
      (if cfg.limo then [ pkgs.limo ] else [])
      (if cfg.proton then [ pkgs.protontricks ] else [])
    ];
  };
}
