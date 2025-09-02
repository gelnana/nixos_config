{ config, pkgs, ... }:

let
  Image = "${config.home.homeDirectory}/.nixos/.icons/noelle.gif";
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
        source = Image;
        height = 21;
        padding = { left = 10; right = 10;};
      };
      display = {
        separator = " | ";
        color = "blue";
      };
      modules = [
      # ───────── Hardware ─────────
      { type = "custom"; format = "┌─────────────Hardware─────────────┐"; outputColor = "cyan"; }
      {
        type = "host";
        key = " PC";
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
      { type = "custom"; format = "└──────────────────────────────────┘"; outputColor = "cyan"; }

      # ───────── Software ─────────
      { type = "custom"; format = "┌─────────────Software─────────────┐"; outputColor = "cyan"; }
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
      { type = "custom"; format = "└──────────────────────────────────┘"; outputColor = "cyan"; }
    ];
  };
};
}
