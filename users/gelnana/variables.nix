{
  # Default applications
  defaultBrowser = "firefox";
  defaultTerminal = "kitty";
  defaultEditor = "neovim";
  defaultFileManager = "org.kde.dolphin";

  # Desktop files for applications
  desktopFiles = {
    browser = ["firefox.desktop"];
    terminal = ["kitty.desktop"];
    editor = ["nvim.desktop"];
    fileManager = ["org.kde.dolphin.desktop"];
    mpv = ["mpv.desktop"];
    imageViewer = ["imv.desktop"];
    pdfViewer = ["org.pwmt.zathura.desktop.desktop"];
    clementine = ["clementine.desktop"];
    discord = ["discordcanary.desktop"];
    spotify = ["spotify.desktop"];
  };

  # Browser MIME types
  browserMimeTypes = [
    "application/x-extension-htm"
    "application/x-extension-html"
    "application/x-extension-shtml"
    "application/x-extension-xht"
    "application/x-extension-xhtml"
    "application/xhtml+xml"
    "text/html"
    "x-scheme-handler/about"
    "x-scheme-handler/ftp"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/unknown"
  ];
}
