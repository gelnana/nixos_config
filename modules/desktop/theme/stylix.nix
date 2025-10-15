{
  pkgs,
  inputs,
  userVars,
  ...
}: let
  apple-fonts = inputs.apple-fonts.packages.${pkgs.system};
in {
  stylix = {
    enable = true;
    autoEnable = true;

    polarity = "dark";

    # Wallpaper
    image = ./../../wallpapers/1.jpg;

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
        name = userVars.fonts.names.serif;
      };

      sansSerif = {
        package = apple-fonts.sf-pro-nerd;
        name = userVars.fonts.names.sansSerif;
      };

      monospace = {
        package = apple-fonts.sf-mono-nerd;
        name = userVars.fonts.names.monospace;
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = userVars.fonts.names.emoji;
      };

      sizes = userVars.fonts.sizes;
    };
  };
}
