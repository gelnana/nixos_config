{pkgs, inputs, ... }:
let
  apple-fonts = inputs.apple-fonts.packages.${pkgs.system};
in
{
  stylix = {
    enable = true;
    autoEnable = true;

    polarity = "dark";

    # Wallpaper
    image = ../wallpaper.png;

    # Base16 scheme: Catppuccin Mocha
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    opacity = {
        applications = 0.93;
        terminal = 0.93;
      };

    # Fonts
    fonts = {
      serif = {
        package = apple-fonts.sf-pro-nerd;
        name = "SFProText Nerd Font";
      };

      sansSerif = {
        package = apple-fonts.sf-pro-nerd;
        name = "SFProText Nerd Font";
      };

      monospace = {
        package = apple-fonts.sf-mono-nerd;
        name = "SFMono Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
          # font size in pt
          applications = 11;
          desktop = 11;
          popups = 11;
          terminal = 11;
        };
    };
  };
}
