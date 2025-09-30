{ pkgs, config, lib, inputs, ... }:

let
  cfg = config.custom.programs.plasma;
in {
  options.custom.programs.plasma = {
    enable = lib.mkEnableOption "Plasma desktop";

    enableCatppuccin = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Catppuccin KDE theme integration";
    };

    catppuccinFlavor = lib.mkOption {
      type = lib.types.str;
      default = "mocha";
      description = "Catppuccin theme flavour";
    };

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
  };

  config = lib.mkIf cfg.enable ({

    services.catppuccin = lib.mkIf cfg.enableCatppuccin {
      enable = true;
      flavor = cfg.catppuccinFlavor;
    };

    services.xserver.enable = lib.mkIf (cfg.enableSddm || cfg.enablePlasma) true;
    services.displayManager.sddm.enable = lib.mkIf cfg.enableSddm true;
    services.desktopManager.plasma6.enable = lib.mkIf cfg.enablePlasma true;

    environment.systemPackages = lib.mkIf cfg.enableKdePackages [
      pkgs.kdePackages.full
    ];

    programs.kdeconnect.enable = lib.mkIf cfg.enableKdeconnect true;
  });
}
