{ config, pkgs, ... }:

let
  porygonImage = "${config.home.homeDirectory}/.nixos/.icons/porygon2.gif";
in
{

  home.packages = with pkgs; [
    alejandra
    deadnix
    statix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
  programs.fastfetch = {
    enable = true;
    settings = {
    logo = {
        type = "kitty-icat";
        source = porygonImage;
        padding = { top = 0; left = 0; right = 0; bottom = 0;};
      };
      display = {
        separator = " | ";
        color = "blue";
      };
      modules = [
        # ───────── Hardware ─────────
        { type = "custom"; format = "┌─────────────Hardware─────────────┐"; outputColor = "cyan"; }
        { type = "host"; key = " PC "; keyColor = "red"; }
        { type = "cpu"; key = "│ ├ "; keyColor = "red"; }
        { type = "gpu"; key = "│ ├󰒆 "; keyColor = "red"; }
        { type = "disk"; key = "│ ├ "; folders = "/"; format = "{size-used} / {size-total} ({size-percentage})"; keyColor = "red"; }
        { type = "memory"; key = "└ └󰍛 "; keyColor = "red"; }
        { type = "custom"; format = "└──────────────────────────────────┘"; outputColor = "cyan"; }

        # ───────── Software ─────────
        { type = "custom"; format = "┌─────────────Software─────────────┐"; outputColor = "cyan"; }
        { type = "os"; key = "󰜗 OS "; keyColor = "green"; }
        { type = "kernel"; key = "│ ├ "; keyColor = "green"; }
        { type = "packages"; key = "│ ├󰏖 "; keyColor = "green"; }
        { type = "localip"; key = "│ ├IP "; keyColor = "green"; }
        { type = "shell"; key = "└ └ "; keyColor = "green"; }
        { type = "de"; key = " DE "; keyColor = "blue"; }
        { type = "wm"; key = "│ ├ "; keyColor = "blue"; }
        { type = "terminal"; key = "│ ├ "; keyColor = "blue"; }
        { type = "custom"; format = "└──────────────────────────────────┘"; outputColor = "cyan"; }

        # ───────── Uptime ─────────
        { type = "custom"; format = "┌──────────────Uptime──────────────┐"; outputColor = "cyan"; }
        { type = "uptime"; key = "  Uptime "; keyColor = "magenta"; }
        { type = "custom"; format = "└──────────────────────────────────┘"; outputColor = "cyan"; }
      ];
    };
  };
}
