{ inputs, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  security.pam.services.hyprlock = {};

  environment.systemPackages = with pkgs; [
    hyprlock
    hypridle
    hyprpolkitagent
  ];
}
