{ lib, pkgs, config, ... }:

let
  cfg = config.custom.programs.communications;
in {
  options.custom.programs.communications = {
    enable = lib.mkEnableOption "Enable communication tools";

    discord = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install Discord";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; lib.concatLists [ 
      (if cfg.discord then [ pkgs.discord ] else [])
    ];
  };
}

