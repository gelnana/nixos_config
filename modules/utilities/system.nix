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
    sops
    age
  ];
}
