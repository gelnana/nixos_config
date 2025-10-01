{ lib, config, pkgs, ... }:
let
  cfg = config.custom.shell.terminals;
in {
  options.custom.shell.terminals = {
    enable = lib.mkEnableOption "terminal emulators";

    kitty = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Kitty terminal";
      };

      fontFamily = lib.mkOption {
        type = lib.types.str;
        default = "SF Pro, JuliaMono";
        description = "Font family for Kitty";
      };

      enableLigatures = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable font ligatures";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = lib.mkIf cfg.kitty.enable {
      enable = true;

      settings = {
        window_padding_width = 5;
        copy_on_select = "clipboard";
        font_family = cfg.kitty.fontFamily;
        bold_font = "SF Pro Bold";
        italic_font = "SF Pro Italic";
        bold_italic_font = "SF Pro Bold Italic";
        enable_ligatures = cfg.kitty.enableLigatures;
      };
    };
  };
}
