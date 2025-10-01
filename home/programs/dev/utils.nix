{ lib, pkgs, config, ... }:

let
  cfg = config.custom.programs.utils;
in
{
  options.custom.programs.utils = {
    enable = lib.mkEnableOption "Enable utility programs";

    ripgrep = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install ripgrep";
    };

    yqGo = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install yq";
    };

    htop = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install htop";
    };

    jupyterAll = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install jupyter";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; lib.concatLists [
      (if cfg.ripgrep then [ pkgs.ripgrep ] else [])
      (if cfg.yqGo then [ pkgs.yq ] else [])
      (if cfg.htop then [ pkgs.htop ] else [])
      (if cfg.jupyterAll then [ pkgs.jupyter ] else [])
    ];
  };
}

