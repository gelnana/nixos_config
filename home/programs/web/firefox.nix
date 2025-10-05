{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.custom.programs.firefox;
in {
  options.custom.programs.firefox = {
    enable = lib.mkEnableOption "Enable Firefox browser";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.firefox-wayland];

    programs.firefox = {
      enable = true;
      package = pkgs.firefox-wayland;
      profiles.default = {
        isDefault = true;
      };
    };
  };
}
