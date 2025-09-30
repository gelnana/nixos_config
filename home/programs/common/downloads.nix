{ lib, pkgs, config, ... }:

let
  cfg = config.custom.programs.common;
in lib.mkIf cfg.enable && cfg.downloads {
  home.packages = with pkgs; [
    qbittorrent
  ];
}
