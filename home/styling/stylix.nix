{ pkgs, ... }:

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
    plasmaThemePackage = klassy;
    fonts = {
      serif = {
        package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
        # name = "SFProDisplay Nerd Font";
        name = "SFProText Nerd Font";
      };

      sansSerif = {
        package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
        name = "SFProText Nerd Font";
        # name = "SFProDisplay Nerd Font";
      };

      monospace = {
        package = inputs.apple-fonts.packages.${pkgs.system}.sf-mono-nerd;
        name = "SFMono Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };

  };
}
