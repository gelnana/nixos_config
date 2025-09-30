{ lib, config, pkgs, ... }:
let
  cfg = config.custom.programs.games.modding;
in {
  options.custom.programs.games.modding = {
    enable = lib.mkEnableOption "game modding tools";

    enableLimo = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Limo mod manager";
    };

    enableNexusMods = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Nexus Mods app";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      lib.optional cfg.enableLimo limo
      ++ lib.optional cfg.enableNexusMods nexusmods-app-unfree;
  };
}
