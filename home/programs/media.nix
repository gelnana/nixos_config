{
  pkgs,
  config,
  ...
}:
# media - control and enjoy audio/video
{
  # imports = [
  # ];

  home.packages = with pkgs; [
    # audio control
    pavucontrol
    playerctl
    pulsemixer
    # images
    imv
    # video
    yt-dlp
    aria2
  ];

  programs = {
    mpv = {
      enable = true;
      config = {
        profile = "gpu-hq";
        hwdec = "auto";
        vo = "gpu";
        ytdl = "yes";
        ytdl-format = "bestvideo+bestaudio/best";
      };
      scripts = with pkgs.mpvScripts; [
        mpris
        quality-menu
        uosc
        sponsorblock
      ];
    };

    obs-studio.enable = true;
  };
}
