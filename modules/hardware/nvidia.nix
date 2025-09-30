{ lib, config, pkgs, ... }:
let
  cfg = config.custom.hardware.nvidia;
in {
  options.custom.hardware.nvidia = {
    enable = lib.mkEnableOption "NVIDIA GPU support";

    openSource = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use open source NVIDIA kernel module (Turing+)";
    };

    enableSettings = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable nvidia-settings GUI";
    };

    enablePrime = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable NVIDIA Prime for hybrid graphics";
    };

    intelBusId = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Intel GPU PCI bus ID (for Prime)";
      example = "PCI:0:2:0";
    };

    nvidiaBusId = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "NVIDIA GPU PCI bus ID (for Prime)";
      example = "PCI:1:0:0";
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;
      open = cfg.openSource;
      nvidiaSettings = cfg.enableSettings;
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      prime = lib.mkIf cfg.enablePrime {
        offload.enable = true;
        intelBusId = cfg.intelBusId;
        nvidiaBusId = cfg.nvidiaBusId;
      };
    };

    hardware.graphics.enable = true;
  };
}
