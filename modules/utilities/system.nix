{ pkgs, lib, username, ... }: {
  # Boot configuration
  boot.plymouth = {
    enable = true;
    theme = lib.mkForce "stylix";
  };

  # Locale & Time
  time.timeZone = "America/Vancouver";

  i18n.defaultLocale = "en_CA.UTF-8";

  # Keyboard layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Nix configuration
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["root" username];
  };

  # Garbage collection
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Networking
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # Basic system services
  services.printing.enable = true;

  # Essential system packages
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    unrar
    fastfetch
  ];
  custom.persist.home.directories = [
    ".nixos"
    ".secrets"
  ];
  custom.persist.root.directories = [
    "/etc/NetworkManager"
  ];
}
