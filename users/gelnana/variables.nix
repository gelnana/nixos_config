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
  fonts = {
    packages = {
      sfPro = "apple-fonts.sf-pro-nerd";
      sfMono = "apple-fonts.sf-mono-nerd";
      notoEmoji = "pkgs.noto-fonts-emoji";
    };

    names = {
      serif = "SFProText Nerd Font";
      sansSerif = "SFProText Nerd Font";
      monospace = "SFMono Nerd Font";
      emoji = "Noto Color Emoji";
      
      terminal = {
        family = "SF Pro, JuliaMono";
        bold = "SF Pro Bold";
        italic = "SF Pro Italic";
        boldItalic = "SF Pro Bold Italic";
      };
    };
    sizes = {
      applications = 10;
      desktop = 10;
      popups = 10;
      terminal = 10;
    };
  };
}
