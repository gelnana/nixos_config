{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.custom.programs.cloud;
in {
  options.custom.programs.cloud = {
    enable = lib.mkEnableOption "Enable cloud utilities";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      docker-compose
      kubectl
      nodejs
      ansible
    ];
  };
}
