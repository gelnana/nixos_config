{ lib, config, pkgs, ... }:
let
  cfg = config.custom.programs.games.utilities;
in {
  options.custom.programs.games.utilities = {
    enable = lib.mkEnableOption "gaming utilities";

    enableProtontricks = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Protontricks for Steam Proton tweaking";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      lib.optional cfg.enableProtontricks protontricks;
  };
}
