{ pkgs, ... }:

let
  myPlasmaTheme = pkgs.stdenv.mkDerivation {
    name = "klassy";
    src = ../../.themes/klassy;
    installPhase = ''
      mkdir -p $out/share/plasma/desktoptheme/Klassy
      cp -r * $out/share/plasma/desktoptheme/Klassy
    '';
  };
in
{
  imports = [
    ../../home/core.nix
    ../../home/programs
    ../../home/shell
  ];

  programs.git = {
    userName = "gelnana";
    userEmail = "chloe@semios.is";
  };

  # Make sure the theme is installed system-wide
  environment.systemPackages = [ myPlasmaTheme ];

  # Set plasma theme declaratively
  programs.plasma-manager.enable = true;
  programs.plasma-manager.theme = "Klassy";  # Name of the installed theme
  programs.plasma-manager.iconTheme = "Breeze";
  programs.plasma-manager.cursorTheme = "Breeze";
}
