{ lib, pkgs, config, ... }:

let
  cfg = config.custom.programs.common;
  modules = [
    ./archives.nix
    ./communications.nix
    ./downloads.nix
    ./organization.nix
  ];
in
lib.foldl' (acc: m: acc // m) {} (map (m: m { inherit lib pkgs config; }) modules)
