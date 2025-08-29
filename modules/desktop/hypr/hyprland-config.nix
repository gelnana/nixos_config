
{ inputs, pkgs, ... }:

{
  # User-specific packages
  home.packages = with pkgs; [
    # Hyprland tools
    pyprland
    hyprpicker
    hyprcursor
    hyprpaper
    hyprsunset

    # Screenshot and utilities
    grim
    slurp
    wl-clipboard
    swappy

    # Desktop environment
    rofi-wayland
    waybar
    dunst
    libnotify

    # Applications
    foot  # terminal
    thunar  # file manager

    # System utilities
    pavucontrol
    networkmanagerapplet
    cliphist
  ];

  # User-specific session variables (if needed)
  home.sessionVariables = {
    # Add any user-specific variables here
  };

  # Hyprland configuration (if you want to manage it with Home Manager)
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    settings = {
      "$mod" = "SUPER";

      bind = [
        "$mod, Return, exec, foot"
        "$mod, Q, killactive"
        "$mod, M, exit"
        "$mod, V, togglefloating"
        "$mod, R, exec, rofi -show drun"
      ];

    };
  };

  # Services that should run per-user
  services = {
    dunst.enable = true;  # Notifications
    cliphist.enable = true;  # Clipboard manager
  };
}
