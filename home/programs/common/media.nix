{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.custom.programs.media;
in {
  options.custom.programs.media = {
    enable = lib.mkEnableOption "media players and tools";
    mpv = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "MPV video player";
      };
      enableScripts = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "MPV scripts";
      };
    };
    enableObs = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "OBS Studio";
    };
    enableAudioControl = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "pavucontrol, playerctl";
    };
    enableImageViewer = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "imv";
    };
    enableDownloaders = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "yt-dlp and aria2";
    };
    enableClementine = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Clementine music player";
    };
    enableSpotify = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Spotify";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      lib.optionals cfg.enableAudioControl [
        pavucontrol
        playerctl
        pulsemixer
      ]
      ++ lib.optional cfg.enableImageViewer imv
      ++ lib.optionals cfg.enableDownloaders [
        yt-dlp
        aria2
      ]
      ++ lib.optional cfg.enableClementine clementine
      ++ lib.optional cfg.enableSpotify spotify;

    programs.mpv = lib.mkIf cfg.mpv.enable {
      enable = true;
      config = {
        profile = "gpu-hq";
        hwdec = "auto";
        vo = "gpu";
        ytdl = "yes";
        ytdl-format = "bestvideo+bestaudio/best";
      };
      scripts = lib.mkIf cfg.mpv.enableScripts (with pkgs.mpvScripts; [
        mpris
        quality-menu
        uosc
        sponsorblock
      ]);
    };
    programs.obs-studio.enable = cfg.enableObs;
  };
}
