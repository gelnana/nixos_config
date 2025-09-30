{
  config,
  pkgs,
  lib,
  ...
}:
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

  config = lib.mkIf cfg.enable {
    home.packages =
      (lib.optionals cfg.enableKrita [ pkgs.krita ])
      ++ (lib.optionals cfg.enableGimp [ pkgs.gimp ])
      ++ (lib.optionals cfg.enableInkscape [ pkgs.inkscape ])
      ++ (lib.optionals cfg.enableClementine [ pkgs.clementine ])
      ++ (lib.optionals cfg.enableLibreOffice [ pkgs.libreoffice-fresh ]);
  };
}
