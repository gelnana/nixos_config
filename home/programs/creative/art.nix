{ config, pkgs, lib, ... }:

let
  cfg = config.custom.programs.art;
in {
  options.custom.programs.art = {
    enable = lib.mkEnableOption "Art and design software";

    enableKrita = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install Krita";
    };

    enableGimp = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install GIMP";
    };

    enableInkscape = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install Inkscape";
    };

    enableClementine = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install Clementine music player";
    };

    enableLibreOffice = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install LibreOffice (fresh)";
    };
  };

  config = {
    home.packages = with pkgs; lib.concatLists [
      (if cfg.enable && cfg.enableKrita then [ pkgs.krita ] else [])
      (if cfg.enable && cfg.enableGimp then [ pkgs.gimp ] else [])
      (if cfg.enable && cfg.enableInkscape then [ pkgs.inkscape ] else [])
      (if cfg.enable && cfg.enableClementine then [ pkgs.clementine ] else [])
      (if cfg.enable && cfg.enableLibreOffice then [ pkgs.libreoffice-fresh ] else [])
    ];
  };
}

