{ config, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jabberwocky-laptop";

  # Enable custom features
  custom = {
    # Software roles
    gaming = {
      enable = true;
      enableSteam = true;
      enableWine = true;
    };

    audio = {
      enable = true;
      enableMusnix = false;
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

    syncthing = {
      enable = true;
      syncPictures = true;
    };

    mounts.enable = false;

    # Hardware
    hardware = {
      nvidia = {
        enable = true;
        openSource = true;
        enableSettings = true;
        # If you have hybrid graphics (Intel + NVIDIA), uncomment and configure:
        enablePrime = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      bluetooth = {
        enable = true;
        powerOnBoot = false;
        showBattery = true;
      };

      laptop = {
        enable = true;
        powerManagement = "tlp";
        tlp = {
          batterySaver = true;
          chargeThresholds = {
            start = 40;
            stop = 80;
          };
        };
      };
    };
  };

  system.stateVersion = "25.05";
}
