{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.custom.themes.catppuccin;
in {
  options.custom.themes.catppuccin = {
    enable = lib.mkEnableOption "Enable Catppuccin theme";
    flavor = lib.mkOption {
      type = lib.types.str;
      default = "mocha";
    };
  };

  config = lib.mkIf cfg.enable {
    catppuccin = {
      enable = true;
      flavor = cfg.flavor;
    };
  };
}
