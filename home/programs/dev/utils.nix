{ lib, pkgs, config, ... }:

let
  cfg = config.custom.programs.common;
in lib.mkIf cfg.enable && cfg.utils {
  home.packages = with pkgs; [
    ripgrep
    yq-go
    htop
    jupyter-all
  ];
}
