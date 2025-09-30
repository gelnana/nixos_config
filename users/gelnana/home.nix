{ pkgs, ... }:

{
  imports = [
    ../../home/core.nix
    ../../home/programs
    ../../home/shell
  ];
    # Enable programs
  custom.programs = {
    # Stylix config
    stylix = {
      enable = true;
      autoEnable = true;
      polarity = "dark";
      image = "$HOME/.config/stylix/wallpaper.jpg";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      opacity = { applications = 0.93; terminal = 0.93; };
      fonts = {
        serif = { package = null; name = "SFProText Nerd Font"; };
        sansSerif = { package = null; name = "SFProText Nerd Font"; };
        monospace = { package = null; name = "SFMono Nerd Font"; };
        emoji = { package = pkgs.noto-fonts-emoji; name = "Noto Color Emoji"; };
        sizes = { applications = 10; desktop = 10; popups = 10; terminal = 10; };
    };

    # Core utilities
    common = {
      enable = true;
      archives = true;
      communications = true;
      downloads = true;
      organization = true;
    };

    # Dev utils
    dev = {
      enable = true;
      utils = true;
      cloud = true;
      git = {
        enable = true;
        userName = "gelnana";
        userEmail = "chloe@semios.is";
      };
    };

    # Browsers
    web = {
      enable = true;
      browsers = {
        firefox = true;
      };
    };

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
      enableDownloaders = true;
    };

    # Creative
    reaper = {
      enable = true;
      enablePlugins = true;
      enableYabridge = true;
    };

    blender.enable = true;

    art = {
      enable = true;
      enableKrita = true;
      enableGimp = true;
      enableInkscape = true;
      enableClementine = true;
      enableLibreOffice = true;
    };

    video = {
      enable = true;
      enableDavinciResolve = true;
    };

    # Games
    games = {
      enable = true;
      launchers = [ "minecraft" "heroic" "ffxiv" ];
      enableModding = true;
      enableProtontricks = true;
    };

    # Editor
    editor = {
      enable = true;
      useNixvim = true;
    };

    git = {
      enable = true;
      userName = "gelnana";
      userEmail = "chloe@semios.is";
    };
  };


}
