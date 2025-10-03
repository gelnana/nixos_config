{ config, lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jabberwocky-laptop";
  networking.hostId = "0cac4cea";

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

    zfs.storage = {
      enable = false;
      data = false;
      archive = false;
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
