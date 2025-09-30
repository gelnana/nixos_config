{ lib, pkgs, config, ... }:

let
  cfg = config.custom.programs.dev;
  modules = [
    ./utils.nix
    ./cloud.nix
    ./git.nix
  ];
in
lib.foldl' (acc: m: acc // m) {} (map (m: m { inherit lib pkgs config; }) modules)
