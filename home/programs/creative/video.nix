{ lib, config, pkgs, ... }:

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

  config = {
    home.packages = with pkgs; lib.concatLists [
      (if cfg.enable && cfg.enableDavinciResolve then [ pkgs.davinci-resolve ] else [])
    ];
  };
}

