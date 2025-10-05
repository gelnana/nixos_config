{
  config,
  userVars,
  ...
}: let
  associations = {
    "audio/*" = userVars.desktopFiles.mpv;
    "video/*" = userVars.desktopFiles.mpv;
    "image/*" = userVars.desktopFiles.imageViewer;
    "application/json" = userVars.desktopFiles.browser;
    "application/pdf" = userVars.desktopFiles.pdfViewer;
    "x-scheme-handler/discord" = userVars.desktopFiles.discord;
    "x-scheme-handler/spotify" = userVars.desktopFiles.spotify;
    "text/plain" = userVars.desktopFiles.editor;
  };
in {
  xdg = {
    enable = true;
    cacheHome = config.home.homeDirectory + "/.local/cache";

    mimeApps = {
      enable = true;
      defaultApplications = associations;
    };

    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
      };
    };
  };
}
