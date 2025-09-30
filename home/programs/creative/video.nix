{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.programs.video;
in {
  options.custom.programs.video = {
    enable = lib.mkEnableOption "Video editing software";

    enableDavinciResolve = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install DaVinci Resolve";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      (lib.optionals cfg.enableDavinciResolve [ pkgs.davinci-resolve ]);
  };
}
