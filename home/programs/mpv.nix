{ config, pkgs, ... }:

{
  programs.mpv = {
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

    package = pkgs.wrapMpv (pkgs.mpv-unwrapped.override {
      vulkanSupport = true;
    }) {
      youtubeSupport = true;
    };

    home.packages = with pkgs; [   # ❌ wrong place
      yt-dlp
      aria2
    ];
  };
}
