{ lib, pkgs, config, ... }:

let
  cfg = config.custom.programs.archives;
in {
  options.custom.programs.archives = {
    enable = lib.mkEnableOption "Enable archive tools";

    p7zip = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install p7zip for 7z archives";
    };

    unrar = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install unrar for RAR archives";
    };

    unar = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install unar for multiple archive formats";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; lib.concatLists[
      (if cfg.p7zip then [ pkgs.p7zip ] else [])
      (if cfg.unrar then [ pkgs.unrar ] else [])
      (if cfg.unar then [ pkgs.unar ] else [])
    ];
  };
}

