{
  config,
  lib,
  ...
}: let
  cfg = config.custom.shell;
  d = config.xdg.dataHome;
  c = config.xdg.configHome;
  cache = config.xdg.cacheHome;
in {
  imports = [
    ./common.nix
    ./nushell
    ./starship.nix
    ./terminals.nix
  ];

  options.custom.shell = {
    enable = lib.mkEnableOption "shell configuration";

    defaultEditor = lib.mkOption {
      type = lib.types.str;
      default = "neovim";
      description = "Default editor";
    };

    defaultBrowser = lib.mkOption {
      type = lib.types.str;
      default = "firefox";
      description = "Default browser";
    };

    defaultTerminal = lib.mkOption {
      type = lib.types.str;
      default = "kitty";
      description = "Default terminal";
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      LESSHISTFILE = cache + "/less/history";
      LESSKEY = c + "/less/lesskey";
      WINEPREFIX = d + "/wine";

      EDITOR = cfg.defaultEditor;
      BROWSER = cfg.defaultBrowser;
      TERMINAL = cfg.defaultTerminal;

      DELTA_PAGER = "less -R";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    };
  };
}
