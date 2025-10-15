{
  config,
  lib,
  pkgs,
  ...
}: {
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

    # Virtualization
    virtualisation.enable = false;

    # Services
    ssh = {
      enable = true;
      enableX11Forwarding = false;
    };

    vpn = {
      enable = true;
      autoStart = true;
      enableCLI = true;
    };

    # Extra storage!
    zfs.storage = {
      enable = true;
      data = true;
      archive = true;
    };

    hardware.bluetooth = {
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

  system.stateVersion = "25.05";
}
