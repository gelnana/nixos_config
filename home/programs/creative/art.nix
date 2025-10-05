{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.custom.programs.art;
in {
  options.custom.programs.art = {
    enable = lib.mkEnableOption "Art and design software";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      krita
      gimp
      inkscape
      blender
      libreoffice-fresh
    ];
  };
}
