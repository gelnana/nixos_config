{ inputs, userVars, ... }:
{
  imports = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
  programs.plasma = {
    enable = true;

    panels = [
      {
        location = "top";
        floating = true;
        height = 32;
        widgets = [
          {
            kickoff = {
              icon = "../../.icons/Enso.svg";
              sortAlphabetically = true;
            };
          }
          "org.kde.plasma.panelspacer"
          {
            digitalClock = {
              date = {
                format.custom = "ddd, MMM dd • yyyy-MM-dd ";
                position = "besideTime";
              };
            };
          }
          "org.kde.plasma.systemtray"
          {
          systemTray.items = {
              shown = [
                "org.kde.plasma.battery"
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
              ];
            };
          "org.kde.plasma.showdesktop"
        ];
      }
      {
        location = "bottom";
        lengthMode = "fit";
        hiding = "autohide";
        floating = true;
        widgets = [
          {
            iconTasks = {
              launchers = [
                "applications:${builtins.head userVars.desktopFiles.terminal}"
                "preferred://browser"
                "applications:org.kde.dolphin.desktop"
              ];
            };
          }
        ];
      }
    ];
    kwin.effects = {
        forceblur.enable = true;
      };
        fonts = {
      general = defaultFont;
      fixedWidth = {
        inherit (defaultFont) pointSize;
        family = userVars.fonts.names.monospace;
      };
      small = defaultFont;
      toolbar = defaultFont;
      menu = defaultFont;
      windowTitle = defaultFont;
    };
    configFile = {
      "kdeglobals"."General"."TerminalApplication" = userVars.defaultTerminal;
    };
  };
}
