{pkgs, ...}: {
  imports = [
    ../../home/core.nix
    ../../home/programs
    ../../home/shell
  ];
  # Enable programs
  custom.programs = {
    # Core utilities
    archives.enable = true;
    downloads.enable = true;
    organization.enable = true;

    # Dev utils
    utils.enable = true;
    cloud.enable = true;
    git = {
      enable = true;
      userName = "gelnana";
      userEmail = "chloe@semios.is";
    };

    # Browsers
    firefox = {
      enable = true;
    };

    game-launchers = true;


    # Media
    media = {
      enable = true;
      mpv = {
        enable = true;
        enableScripts = true;
      };
      enableObs = true;
      enableAudioControl = true;
      enableImageViewer = true;
      enableClementine = true;
      enableDownloaders = true;
      enableSpotify = true;
    };

    # Creative
    art.enable = true;
    reaper = {
      enable = true;
      enablePlugins = true;
      enableYabridge = true;
    };
  };
  custom.shell = {
    enable = true;
    defaultEditor = "neovim";
    defaultBrowser = "firefox";
    defaultTerminal = "kitty";

    common = {
      enable = true;
      enableDirenv = true;
      enableFastfetch = true;
    };

    nushell = {
      enable = true;
      enableCarapace = true;
    };

    starship = {
      enable = true;
      enableNushell = true;
      enableBash = false;
      enableZsh = false;
    };

    terminals = {
      enable = true;
      kitty = {
        enable = true;
        fontFamily = "SF Pro, JuliaMono";
        enableLigatures = true;
      };
    };
  };
}
