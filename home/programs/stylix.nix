{ config, pkgs, lib, ... }:

let
  appleFonts = null; # or pkgs.apple-fonts
in
{
  options.programs.stylix = {
    enable = lib.mkEnableOption "Enable Stylix user integration";
    autoEnable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  config = lib.mkIf config.programs.stylix.enable {
    home.packages = with pkgs; [
      pkgs.noto-fonts-emoji
      # add other fonts
    ];

    home.sessionVariables = {
      STYLIX_POLARITY = "dark";
    };

    home.file.".config/stylix/config.json".text = builtins.toJSON {
      enable = true;
      autoEnable = true;
      polarity = "dark";
    };
  };
}
