{ config, lib, pkgs, ... }: {

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jabberwocky-desktop";
  networking.hostId = "9f0b8720";

  # Enable custom features
  custom = {
    # Plasma desktop
    programs.plasma = {
      enable = true;
      enableSddm = true;
      enablePlasma = true;
      enableKdePackages = true;
      enableKdeconnect = true;
      enableForceBlur = true;
    };

    # Software roles
    gaming = {
      enable = true;
      enableSteam = true;
      enableWine = true;
    };

    audio = {
      enable = true;
      enableMusnix = true;
      enableJack = false;
    };

    dev = {
      enable = true;
      enableDocker = true;
    };

    # Services
    ssh = {
      enable = true;
      enableX11Forwarding = false;
    };


    # mounts.enable = true;

    # Hardware
    hardware = {
      nvidia = {
        enable = false;
        openSource = false;
        enableSettings = false;
        # If you have hybrid graphics (Intel + NVIDIA), uncomment and configure:
        # enablePrime = true;
        # intelBusId = "PCI:0:2:0";
        # nvidiaBusId = "PCI:1:0:0";
      };

      bluetooth = {
        enable = true;
        powerOnBoot = true;
        showBattery = true;
      };

      # laptop = {
      #   enable = false;
      #   powerManagement = "tlp";
      #   tlp = {
      #     batterySaver = true;
      #     chargeThresholds = {
      #       start = 40;
      #       stop = 80;
      #     };
      #   };
      # };
    };
  };

  system.stateVersion = "25.05";
}
