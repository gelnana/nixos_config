{ lib, config, ... }:
let
  cfg = config.custom.shell.starship;
in {
  options.custom.shell.starship = {
    enable = lib.mkEnableOption "Starship prompt";

    enableBash = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Bash integration";
    };

    enableZsh = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Zsh integration";
    };

    enableNushell = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Nushell integration";
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables.STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";

    programs.starship = {
      enable = true;
      enableBashIntegration = cfg.enableBash;
      enableZshIntegration = cfg.enableZsh;
      enableNushellIntegration = cfg.enableNushell;

      settings = {
        character = {
          success_symbol = "[›](bold green)";
          error_symbol = "[›](bold red)";
        };
      };
    };
  };
}
