{ pkgs, lib, config, ... }:
let
  cfg = config.custom.programs.media;
in {
  options.custom.programs.media = {
    enable = lib.mkEnableOption "media players and tools";

    mpv = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable MPV video player with scripts";
      };

      enableScripts = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable MPV scripts (MPRIS, uosc, etc)";
      };
    };

    enableObs = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable OBS Studio";
    };

    enableAudioControl = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install audio control tools (pavucontrol, playerctl)";
    };

    enableImageViewer = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install imv image viewer";
    };

    enableDownloaders = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install yt-dlp and aria2";
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
      ];

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
