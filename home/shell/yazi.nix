{
  config,
  pkgs,
  ...
}: {
  programs.yazi = {
    enable = true;

    plugins = {
      mount = pkgs.yaziPlugins.mount;
      git = pkgs.yaziPlugins.git;
      lazygit = pkgs.yaziPlugins.lazygit;
      projects = pkgs.yaziPlugins.projects;
      ouch = pkgs.yaziPlugins.ouch;
      chmod = pkgs.yaziPlugins.chmod;
      starship = pkgs.yaziPlugins.starship;
      zfs = pkgs.yaziPlugins.time-travel;
      duckdb = pkgs.yaziPlugins.duckdb;
    };

    initLua = ''
	require("starship"):setup()
	require("projects"):setup({
          save = {
          method = "yazi", -- yazi | lua
          yazi_load_event = "@projects-load", -- event name when loading projects in `yazi` method
          lua_save_path = "", -- path of saved file in `lua` method, comment out or assign explicitly
                              -- default value:
                              -- windows: "%APPDATA%/yazi/state/projects.json"
                              -- unix: "~/.local/state/yazi/projects.json"
      },
      last = {
          update_after_save = true,
          update_after_load = true,
          load_after_start = false,
      },
      merge = {
          event = "projects-merge",
          quit_after_merge = false,
      },
      event = {
          save = {
              enable = true,
              name = "project-saved",
          },
          load = {
              enable = true,
              name = "project-loaded",
          },
          delete = {
              enable = true,
              name = "project-deleted",
          },
          delete_all = {
              enable = true,
              name = "project-deleted-all",
          },
          merge = {
              enable = true,
              name = "project-merged",
          },
      },
      notify = {
          enable = true,
          title = "Projects",
          timeout = 3,
          level = "info",
      },
	})
	require("git"):setup()
	require("duckdb"):setup()
    '';

    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    enableFishIntegration = true;

    settings = {
      mgr = {
        ratio = [1 4 3];

        prepend_previewers = [
          {
            mime = "application/*zip";
            run = "ouch";
          }
          {
            mime = "application/x-tar";
            run = "ouch";
          }
          {
            mime = "application/x-bzip2";
            run = "ouch";
          }
          {
            mime = "application/x-7z-compressed";
            run = "ouch";
          }
          {
            mime = "application/x-rar";
            run = "ouch";
          }
          {
            mime = "application/vnd.rar";
            run = "ouch";
          }
          {
            mime = "application/x-xz";
            run = "ouch";
          }
          {
            mime = "application/xz";
            run = "ouch";
          }
          {
            mime = "application/x-zstd";
            run = "ouch";
          }
          {
            mime = "application/zstd";
            run = "ouch";
          }
          {
            mime = "application/java-archive";
            run = "ouch";
          }
        ];

        prepend_fetchers = [
          {
            id = "git";
            name = "*";
            run = "git";
          }
          {
            id = "git";
            name = "*/";
            run = "git";
          }
        ];
        prepend_keymap = [
          #  mount
          {
            on = ["M"];
            run = "plugin mount";
          }
          #  ouch
          {
            on = ["C"];
            run = "plugin ouch";
            desc = "Compress with ouch";
          }
          {
            on = ["c" "m"];
            run = "plugin chmod";
            desc = "Chmod on selected files";
          }
          #  duckdb
          {
            on = ["g" "u"];
            run = "plugin duckdb -ui";
            desc = "open with duckdb ui";
          }
          {
            on = ["g" "o"];
            run = "plugin duckdb -open";
            desc = "open with duckdb";
          }
          {
            on = "H";
            run = "plugin duckdb -1";
            desc = "Scroll one column to the left";
          }
          {
            on = "L";
            run = "plugin duckdb +1";
            desc = "Scroll one column to the right";
          }
          # projects
          {
            on = ["P" "s"];
            run = "plugin projects save";
            desc = "Save current project";
          }
          {
            on = ["P" "l"];
            run = "plugin projects load";
            desc = "Load project";
          }
          {
            on = ["P" "P"];
            run = "plugin projects load_last";
            desc = "Load last project";
          }
          {
            on = ["P" "d"];
            run = "plugin projects delete";
            desc = "Delete project";
          }
          {
            on = ["P" "D"];
            run = "plugin projects delete_all";
            desc = "Delete all projects";
          }
          {
            on = ["P" "m"];
            run = "plugin projects 'merge current'";
            desc = "Merge current tab to other projects";
          }
          {
            on = ["P" "M"];
            run = "plugin projects 'merge all'";
            desc = "Merge current project to other projects";
          }
          #  time travel
          {
            on = ["z" "h"];
            run = "plugin time-travel --args=prev";
            desc = "Go to previous snapshot";
          }
          {
            on = ["z" "l"];
            run = "plugin time-travel --args=next";
            desc = "Go to next snapshot";
          }
          {
            on = ["z" "e"];
            run = "plugin time-travel --args=exit";
            desc = "Exit browsing snapshots";
          }
        ];
      };
    };
  };
}
