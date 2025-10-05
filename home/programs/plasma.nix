{
  inputs,
  userVars,
  ...
}: {
  imports = [inputs.plasma-manager.homeManagerModules.plasma-manager];

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
              icon = "${builtins.toString inputs.self}/.icons/Enso.svg";
              sortAlphabetically = true;
            };
          }
          "org.kde.plasma.panelspacer"
          {
            digitalClock = {
              date = {
                format.custom = "ddd, MMM dd • yyyy-MM-dd";
                position = "besideTime";
              };
              font = {
                family = userVars.fonts.names.sansSerif;
                size = 8;
              };
            };
          }
          {
            systemTray.items.shown = [
              "org.kde.plasma.battery"
              "org.kde.plasma.networkmanagement"
              "org.kde.plasma.volume"
            ];
          }
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

    fonts = let
      g = {
        family = userVars.fonts.names.sansSerif;
        pointSize = userVars.fonts.sizes.desktop;
      };
    in {
      general = g;
      fixedWidth = {
        family = userVars.fonts.names.monospace;
        pointSize = userVars.fonts.sizes.desktop;
      };
      small = g;
      toolbar = g;
      menu = g;
      windowTitle = g;
    };


    configFile = {
      "kwinrc"."Plugins"."blurEnabled" = false;
      "kwinrc"."Plugins"."forceblurEnabled" = true;
      "kdeglobals"."General"."TerminalApplication" = userVars.defaultTerminal;
    };
  };
}
