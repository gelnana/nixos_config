{ pkgs,
  config,
  lib,
  inputs,
  ...
}:

let
  myPlasmaTheme = pkgs.stdenv.mkDerivation {
    name = "klassy";
    src = ../../.themes/klassy;
    installPhase = ''
      mkdir -p $out/share/plasma/desktoptheme
      cp -r * $out/share/plasma/desktoptheme/
    '';
  };
in
{
  stylix = {
    enable = true;
    autoEnable = true;
    targets = {
        plasma.enable = true;
        };
    plasmaThemePackage = myPlasmaTheme;


  };
}
