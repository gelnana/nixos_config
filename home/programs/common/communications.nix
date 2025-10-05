{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.custom.programs.communications;
in {
  options.custom.programs.communications = {
    enable = lib.mkEnableOption "Enable communication tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      discord
    ];
  };
}
