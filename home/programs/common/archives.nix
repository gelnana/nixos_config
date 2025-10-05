{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.custom.programs.archives;
in {
  options.custom.programs.archives = {
    enable = lib.mkEnableOption "Enable archive tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      p7zip
      unrar
      unar
    ];
  };
}
