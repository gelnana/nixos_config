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
      {
        type = "host";
        key = " PC";
        keyColor = "red";
        format = "{name}"; # Remove vendor/version if too long
      }
      {
        type = "cpu";
        key = "│ ├ ";
        keyColor = "red";
        format = "{name}"; # Remove @ frequency and core count
        showPeCoreCount = false;
      }
      {
        type = "gpu";
        key = "│ ├󰒆 ";
        keyColor = "red";
        format = "{name}"; # Remove vendor prefix and memory info
        hideType = true;
        hideMemory = true;
      }
      {
        type = "disk";
        key = "│ ├ ";
        folders = "/";
        format = "{size-used}/{size-total}"; # Removed percentage for brevity
        keyColor = "red";
      }
      {
        type = "memory";
        key = "└ └󰍛 ";
        keyColor = "red";
        format = "{used}/{total}"; # Simplified format
      }
      { type = "custom"; format = "└──────────────────────────────────┘"; outputColor = "cyan"; }

      # ───────── Software ─────────
      { type = "custom"; format = "┌─────────────Software─────────────┐"; outputColor = "cyan"; }
      {
        type = "os";
        key = "󰜗 OS ";
        keyColor = "green";
        format = "{pretty-name}"; # Use pretty name instead of full name
      }
      {
        type = "kernel";
        key = "│ ├ ";
        keyColor = "green";
        format = "{release}"; # Just version, no architecture
      }
      {
        type = "packages";
        key = "│ ├󰏖 ";
        keyColor = "green";
        format = "{all}"; # Just total count
      }
      {
        type = "localip";
        key = "│ ├IP";
        keyColor = "green";
        format = "{ipv4}"; # IPv4 only, shorter
      }
      {
        type = "shell";
        key = "└ └ ";
        keyColor = "green";
      }
      {
        type = "de";
        key = " DE ";
        keyColor = "blue";
        format = "{pretty-name}"; # Shorter DE name
      }
      {
        type = "wm";
        key = "│ ├ ";
        keyColor = "blue";
        format = "{pretty-name}"; # Shorter WM name
      }
      {
        type = "terminal";
        key = "│ └ ";
        keyColor = "blue";
      }
      { type = "custom"; format = "└──────────────────────────────────┘"; outputColor = "cyan"; }

      # ───────── Uptime ─────────
      { type = "custom"; format = "┌──────────────Uptime──────────────┐"; outputColor = "cyan"; }
      {
        type = "uptime";
        key = "  Uptime ";
        keyColor = "magenta";
        format = "{days}d {hours}h {minutes}m"; # Compact uptime format
      }
      { type = "custom"; format = "└──────────────────────────────────┘"; outputColor = "cyan"; }
    ];
  };
};
}
