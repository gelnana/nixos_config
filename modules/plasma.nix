{ pkgs, config, lib, inputs, ... }:

{
  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
}
