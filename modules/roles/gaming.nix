{ pkgs, lib, config, ... }:
let
  cfg = config.custom.gaming;
in {
  options.custom.gaming = {
    enable = lib.mkEnableOption "gaming support";

    enableSteam = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Steam";
    };

    enableWine = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Wine and Windows compatibility";
    };
  };

  config = lib.mkIf cfg.enable {
    # Steam configuration
    programs.steam = lib.mkIf cfg.enableSteam {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
    };

    hardware.steam-hardware.enable = lib.mkIf cfg.enableSteam true;
    programs.gamemode.enable = true;

    # Graphics support
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa.drivers
        vulkan-loader
        vulkan-tools
        vulkan-validation-layers
      ];
    };

    # Game launchers and tools
    environment.systemPackages = with pkgs; [
      lutris
      bottles
      heroic
      gamescope
      corectrl
    ] ++ lib.optionals cfg.enableWine [
      wineWowPackages.stagingFull
      winetricks
      dxvk
    ];

    # Gaming cachix
    nix.settings = {
      substituters = ["https://nix-gaming.cachix.org"];
      trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };

    custom.persist = {
      home.directories = [
        ".local/share/Steam"
        ".config/mangohud"
        ".config/unity3d"
        ".steam"
      ];
    };
  };
}
