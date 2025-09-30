{ lib, pkgs, config, ... }:

let
  cfg = config.custom.programs.common;
in lib.mkIf cfg.enable && cfg.organization {
  home.packages = with pkgs; [
    calibre
    zotero_7
    qnotero
  ];
}
