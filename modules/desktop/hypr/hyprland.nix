{ inputs, pkgs, ... }:

{
  # System-wide Hyprland configuration (NixOS level)
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  # System-wide environment variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };

  # System services
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  # XDG portal configuration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  # Security for hyprlock
  security.pam.services.hyprlock = {};

  # System-wide packages
  environment.systemPackages = with pkgs; [
    hyprlock
    hypridle
    hyprpolkitagent
  ];
}
