{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.custom.shell.common;
  Image = "${config.home.homeDirectory}/.nixos/.icons/eye.gif";
in {
  options.custom.shell.common = {
    enable = lib.mkEnableOption "common shell tools and utilities";

    enableDirenv = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable direnv for per-directory environments";
    };

    enableFastfetch = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable fastfetch system info";
    };

    fastfetchLogo = lib.mkOption {
      type = lib.types.str;
      default = Image;
      description = "Path to fastfetch logo image";
    };

    enableDevTools = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable development tools (alejandra, deadnix, statix)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      lib.optional cfg.enableDevTools julia-mono
      ++ lib.optional cfg.enableDevTools devenv
      ++ lib.optionals cfg.enableDevTools [
        deadnix
        statix
      ];

    programs.direnv = lib.mkIf cfg.enableDirenv {
      enable = true;
      nix-direnv.enable = true;
      enableNushellIntegration = true;
    };

    programs.fastfetch = lib.mkIf cfg.enableFastfetch {
      enable = true;
      settings = {
        logo = {
          type = "kitty-icat";
          source = cfg.fastfetchLogo;
          height = 21;
          padding = {
            left = 10;
            right = 10;
          };
        };
        display = {
          separator = " | ";
          color = "blue";
        };
        modules = [
          # ───────── Hardware ─────────
          {
            type = "custom";
            format = "┌─────────────Hardware─────────────┐";
            outputColor = "cyan";
          }
          {
            type = "host";
            key = "  PC";
            keyColor = "red";
            format = "{name}";
          }
          {
            type = "cpu";
            key = "│ ├ ";
            keyColor = "red";
            format = "{name}";
            showPeCoreCount = false;
          }
          {
            type = "gpu";
            key = "│ ├󰒆 ";
            keyColor = "red";
            format = "{name}";
            hideType = true;
            hideMemory = true;
          }
          {
            type = "disk";
            key = "│ ├ ";
            folders = "/";
            format = "{size-used}/{size-total}";
            keyColor = "red";
          }
          {
            type = "memory";
            key = "│ └󰍛 ";
            keyColor = "red";
            format = "{used}/{total}";
          }
          {
            type = "custom";
            format = "└──────────────────────────────────┘";
            outputColor = "cyan";
          }

          # ───────── Software ─────────
          {
            type = "custom";
            format = "┌─────────────Software─────────────┐";
            outputColor = "cyan";
          }
          {
            type = "os";
            key = "󰜗 OS ";
            keyColor = "green";
            format = "{pretty-name}";
          }
          {
            type = "kernel";
            key = "│ ├ ";
            keyColor = "green";
            format = "{release}";
          }
          {
            type = "packages";
            key = "│ ├󰏖 ";
            keyColor = "green";
            format = "{all}";
          }
          {
            type = "localip";
            key = "│ ├IP";
            keyColor = "green";
            format = "{ipv4}";
          }
          {
            type = "shell";
            key = "│ └ ";
            keyColor = "green";
          }
          {
            type = "de";
            key = " DE ";
            keyColor = "blue";
            format = "{pretty-name}";
          }
          {
            type = "wm";
            key = "│ ├ ";
            keyColor = "blue";
            format = "{pretty-name}";
          }
          {
            type = "terminal";
            key = "│ └ ";
            keyColor = "blue";
          }
          {
            type = "custom";
            format = "└──────────────────────────────────┘";
            outputColor = "cyan";
          }
        ];
      };
    };
  };
}
