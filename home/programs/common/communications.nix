{ lib, pkgs, config, ... }:

let
  cfg = config.custom.programs.common;
in lib.mkIf cfg.enable && cfg.communications {
  home.packages = with pkgs; [
    discord
    mailspring
  ];
}
