{ lib, pkgs, config, ... }:

let
  cfg = config.custom.programs.common;
in lib.mkIf cfg.enable && cfg.cloud {
  home.packages = with pkgs; [
    docker-compose
    kubectl
    nodejs
    ansible
  ];
}
