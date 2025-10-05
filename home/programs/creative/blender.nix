{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.custom.programs.blender;
in {
  options.custom.programs.blender = {
    enable = lib.mkEnableOption "Blender 3D software";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.blender;
      description = "Blender package to use";
    };
  };

  config = {
    home.packages =
      if cfg.enable
      then [cfg.package]
      else [];
  };
}
