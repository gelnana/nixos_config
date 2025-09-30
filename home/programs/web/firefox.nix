{ lib, pkgs, config, user, ... }:

let
  cfg = config.custom.programs.web;
in lib.mkIf cfg.enable {

  home.packages = lib.concatMap (b: lib.optionals (cfg.browsers.${b}) [ pkgs.${b} ]) (builtins.attrNames cfg.browsers);

  # Firefox configuration
  programs.firefox = lib.mkIf cfg.browsers.firefox {
    enable = true;
    package = pkgs.firefox-wayland;

    profiles.${user} = {
      default = true;
    };
  };

  # Set default browser (xdg)
  xdg.mimeApps.defaultApplications = let
    browser = if cfg.browsers.firefox then "firefox.desktop"
              else if cfg.browsers.librewolf then "librewolf.desktop"
              else null;
  in lib.mkIf browser != null {
    "x-scheme-handler/http"  = browser;
    "x-scheme-handler/https" = browser;
    "text/html"               = browser;
    "text/xml"                = browser;
    "application/xhtml_xml"   = browser;
    "x-scheme-handler/ftp"    = browser;
  };

  xdg.mimeApps.associations.added = xdg.mimeApps.defaultApplications;

}
