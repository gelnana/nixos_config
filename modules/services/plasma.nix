{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.custom.programs.plasma;
in {
  options.custom.programs.plasma = {
    enable = lib.mkEnableOption "Plasma desktop";

    enableSddm = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable SDDM display manager";
    };

    enablePlasma = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Plasma 6 desktop environment";
    };

    enableKdePackages = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install KDE packages (kdePackages.full) into environment.systemPackages";
    };

    enableKdeconnect = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable KDE Connect";
    };

    enableForceBlur = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable KWin ForceBlur effect";
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.enable = lib.mkIf (cfg.enableSddm || cfg.enablePlasma) true;
    services.displayManager.sddm.enable = lib.mkIf cfg.enableSddm true;
    services.desktopManager.plasma6.enable = lib.mkIf cfg.enablePlasma true;

    environment.systemPackages = lib.concatLists [
      (
        if cfg.enableKdePackages
        then [pkgs.kdePackages.full]
        else []
      )
      (
        if cfg.enableForceBlur
        then [inputs.kwin-effects-forceblur.packages.${pkgs.system}.default]
        else []
      )
    ];

    programs.kdeconnect.enable = lib.mkIf cfg.enableKdeconnect true;
  };
}
