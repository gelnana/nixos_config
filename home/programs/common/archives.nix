{ lib, pkgs, config, ... }:

let
  cfg = config.custom.programs.common;
in lib.mkIf cfg.enable && cfg.archives {
  home.packages = with pkgs; [
    zip
    unzip
    p7zip
  ];
}
