{
  lib,
  config,
  ...
}: let
  cfg = config.custom.hardware.laptop;
in {
  options.custom.hardware.laptop = {
    enable = lib.mkEnableOption "laptop-specific optimizations";

    powerManagement = lib.mkOption {
      type = lib.types.enum ["tlp" "power-profiles-daemon" "auto-cpufreq"];
      default = "tlp";
      description = "Power management solution";
    };

    tlp = {
      batterySaver = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Aggressive battery saving settings";
      };

      chargeThresholds = {
        start = lib.mkOption {
          type = lib.types.int;
          default = 40;
          description = "Start charging at this percentage";
        };
        stop = lib.mkOption {
          type = lib.types.int;
          default = 80;
          description = "Stop charging at this percentage";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable touchpad
    services.xserver.libinput.enable = true;

    # Power management
    services.power-profiles-daemon.enable = cfg.powerManagement == "power-profiles-daemon";

    services.tlp = lib.mkIf (cfg.powerManagement == "tlp") {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT =
          if cfg.tlp.batterySaver
          then 20
          else 50;

        START_CHARGE_THRESH_BAT0 = cfg.tlp.chargeThresholds.start;
        STOP_CHARGE_THRESH_BAT0 = cfg.tlp.chargeThresholds.stop;
      };
    };

    # Enable thermald for Intel CPUs
    services.thermald.enable = lib.mkDefault true;
  };
}
