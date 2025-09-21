{
  pkgs,
  lib,
  username,
  ...
}: {

  boot = {
      plymouth = {
        enable = true;
        theme = lib.mkForce "stylix";
      };
    };
  
  environment.shells = [
    pkgs.nushell
  ];
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.nushell;
  };

  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs = {
      nh = {
        enable = true;
        clean.enable = false;
        flake = "/etc/nixos";
    };
  };

  #enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 2d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall = {
    allowedUDPPortRanges = [
      { from = 2234; to = 2234; } # for soulseek
    ];
  };
    # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no"; # disable root login
      PasswordAuthentication = false; # disable password login
    };
    openFirewall = true;
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.syncthing = {
    enable = true;
    group = "users";
    user  = "${username}";
    dataDir = "/home/${username}/Documents";
    configDir = "/home/${username}/.config/syncthing";
    overrideDevices = false;
    overrideFolders = false;
    openDefaultPorts = true;

    settings = {
      devices = {
        "desktop" = { id = "GMVTI4B-DZRE3OZ-DSQS7MI-MAKOQIB-LO37DD7-VQXCZMM-OFVR6NB-6VXY3AH"; };
        "laptop" = { id = "4MXB6CU-FRYORZH-FLGKYOB-NNSINZP-Q2EZ5VC-QIEMVGM-GNPNIRV-LFRQJQH"; };
    };
      folders = {
        "Pictures" = {
          path = "/home/${username}/Pictures/";
          devices = ["desktop" "laptop"];
        };
      };
      gui = {
        user = "${username}";
        password = "j4bb3rw0cky";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    unrar
    curl
    git
    fastfetch
    wineWowPackages.stagingFull
    bottles-unwrapped
    winetricks
    dxvk
  ];

  hardware.opengl = {
    enable = true;

    extraPackages = with pkgs; [
      mesa.drivers
      vulkan-loader
      vulkan-tools
      vulkan-validation-layers
    ];

    # 32-bit packages for running Wine
    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa.drivers
      vulkan-loader
    ];
  };

  nix.settings = {
    substituters = ["https://nix-gaming.cachix.org"];
    trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
    trusted-users = [ "root" "${username}" ];
  };
  virtualisation.docker = {
    enable = true;
  };
}
