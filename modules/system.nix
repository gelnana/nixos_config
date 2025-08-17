{
  pkgs,
  lib,
  username,
  ...
}: {
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
    options = lib.mkDefault "--delete-older-than 7d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.syncthing = {
    enable = true;
    group = "maingroup";
    user  = "${username}";
    dataDir = "/home/${username}/Documents";
    overrideDevices = true;
    overrideFolders = true;
    openDefaultPorts = true;
    settings = {
      devices = { 
        "desktop" = { id = "ANPIQQR-UEBYECU-2ZM33TI-LBOGQXV-IVAP5VR-CGNRAH2-BCE6TU3-UMQQDAX"; };
        "laptop" = { id = "CRWBDUU-V6ZIOWN-TBP6RPJ-UEA3ZYU-SP53UN5-MLNFT7J-KPSDODH-YQHCZQR"; };
    };
      folders = {
        "Documents" = {
          path = "/home/${username}/Documents";
          devices = ["desktop" "laptop"];
        };
        "Pictures" = {
          path = "/home/${username}/Pictures/";
          devices = ["desktop" "laptop"];
        };
      };
      gui = {
        user = "${username}";
        password = "j4bb3rw0cky";
      }
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    curl
    mpv
    git
    fastfetch
  ];


}
