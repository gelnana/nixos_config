{
  lib,
  config,
  pkgs,
  userVars,
  ...
}: let
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
        default = userVars.fonts.names.terminal.family;
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
        bold_font = userVars.fonts.names.terminal.bold;
        italic_font = userVars.fonts.names.terminal.italic;
        bold_italic_font = userVars.fonts.names.terminal.boldItalic;
        enable_ligatures = cfg.kitty.enableLigatures;
      };
    };
  };
}
