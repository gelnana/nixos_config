{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.custom.programs.utils;
in {
  options.custom.programs.utils = {
    enable = lib.mkEnableOption "Utilities";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      devenv
      tmux
      perl
      statix
      deadnix
      ripgrep
      yq
      htop
      jupyter
      papis
      yq
    ];
  };
}
