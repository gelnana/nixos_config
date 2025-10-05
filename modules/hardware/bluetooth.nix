{
  lib,
  config,
  ...
}: let
  cfg = config.custom.hardware.bluetooth;
in {
  options.custom.hardware.bluetooth = {
    enable = lib.mkEnableOption "Bluetooth support";

    powerOnBoot = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Power on Bluetooth adapter on boot";
    };

    showBattery = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Show battery charge of Bluetooth devices";
    };

    enableBlueman = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Blueman GUI manager";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = cfg.powerOnBoot;
      settings.General = lib.mkIf cfg.showBattery {
        Experimental = true;
      };
    };

    services.blueman.enable = cfg.enableBlueman;
  };
}
