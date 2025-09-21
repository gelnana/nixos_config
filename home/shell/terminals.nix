{ config, pkgs, ... }:
{

  programs= {
    kitty = {
      enable = true;
      enableGitIntegration = true;

      settings = {
        window_padding_width = 5;
        copy_on_select = "clipboard";
        font_family = "SF Pro, JuliaMono";
        bold_font = "SF Pro Bold";
        italic_font = "SF Pro Italic";
        bold_italic_font = "SF Pro Bold Italic";

        enable_ligatures = true;
      };
    };
  };
  }
