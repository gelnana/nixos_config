{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.custom.programs.games;
in {
  options.custom.programs.games = {
    enable = lib.mkEnableOption "Enable games";

    launchers = lib.mkOption {
      type = lib.types.attrsOf lib.types.bool;
      default = {};
      description = "Game launchers enabled";
    };

    utilities = lib.mkOption {
      type = lib.types.attrsOf lib.types.bool;
      default = {};
      description = "Gaming utilities";
    };

    modding = lib.mkOption {
      type = lib.types.attrsOf lib.types.bool;
      default = {};
      description = "Game modding tools";
    };
  };
  #  custom.persist = {
  #    home.directories = [
  #      ".local/share/Steam"
  #      ".steam"
  #    ];
  #  };
}
