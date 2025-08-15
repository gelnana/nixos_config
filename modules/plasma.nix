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
in {
  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs.plasma-manager.enable = true;
  programs.plasma-manager.theme = myPlasmaTheme;  # Set your desired theme
  programs.plasma-manager.iconTheme = "Breeze";  # Set your icon theme
  programs.plasma-manager.cursorTheme = "Breeze";  # Set your cursor theme

  environment.systemPackages =
      (with pkgs; [
        applet-window-title # Shows the application title and icon for active window
        spectacle # Spectacle screenshoting tool replacement
        gparted # Partition Manager
        haruna # Video Player
        qdirstat # Disk usage statistics
        #nur.repos.shadowrz.klassy-qt6
        nur.repos.skiletro.applet-darwinmenu # macOS-like "start menu"
        nur.repos.skiletro.applet-kara # Workspace indicator
        plasmusic-toolbar # Better media player widget
      ])
            ++ (with pkgs.kdePackages; [
        kcalc # Calculator
        kzones # KWin script for snapping windows into zones
      ]);
}
