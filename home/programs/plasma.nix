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
              icon = "nix-snowflake-white";
              sortAlphabetically = true;
            };
          }
          "org.kde.plasma.panelspacer"
          {
            digitalClock = {
              date = {
                format.custom = "ddd, MMM dd • yyyy-MM-dd •";
                position = "besideTime";
              };
            };
          }
          "org.kde.plasma.panelspacer"
          "org.kde.plasma.systemtray"
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

    configFile = {
      "kdeglobals"."General"."TerminalApplication" = userVars.defaultTerminal;
    };
  };
}
