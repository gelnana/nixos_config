-- lua/myLuaConf/plugins/tidal.lua
return {
  {
    "thgrund/tidal.nvim",
    opts = {
    {
  --- Configure TidalLaunch command
  boot = {
    tidal = {
      --- Command to launch ghci with tidal installation
      cmd = "ghci",
      args = {
        "-v0",
      },
      --- Tidal boot file path
      file = "/Users/Your/Path/to/tidalcycles/BootTidal.hs",
      enabled = true,
      highlight = {
        autostart = false,
        styles = {
          osc = {
            ip = "127.0.0.1",
            port = 3335,
          },
          -- [Tidal ID] -> hl style 
          custom = {
            ["drums"] = { bg = "#e7b9ed", foreground = "#000000" },
            ["2"] = { bg = "#b9edc7", foreground = "#000000" },
          },
          global = { baseName = "CodeHighlight", style = { bg = "#7eaefc", foreground = "#000000" } },
        },
        events = {
          osc = {
            ip = "127.0.0.1",
            port = 6013,
          },
        },
        fps = 30,
      },
    },
    sclang = {
      --- Command to launch SuperCollider
      cmd = "sclang",
      args = {},
      --- SuperCollider boot file
      file = vim.api.nvim_get_runtime_file("bootfiles/BootSuperDirt.scd", false)[1],
      enabled = false,
    },
    split = "v",
  },
  --- Default keymaps
  --- Set to false to disable all default mappings
  --- @type table | nil
  mappings = {
    send_line = { mode = { "i", "n" }, key = "<S-CR>" },
    send_visual = { mode = { "x" }, key = "<S-CR>" },
    send_block = { mode = { "i", "n", "x" }, key = "<M-CR>" },
    send_node = { mode = "n", key = "<leader><CR>" },
    send_silence = { mode = "n", key = "<leader>d" },
    send_hush = { mode = "n", key = "<leader><Esc>" },
  },
  ---- Configure highlight applied to selections sent to tidal interpreter
  selection_highlight = {
    --- Highlight definition table
    --- see ':h nvim_set_hl' for details
    --- @type vim.api.keyset.highlight
    highlight = { link = "IncSearch" },
    --- Duration to apply the highlight for
    timeout = 150,
  },
}
    },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate", -- run TSUpdate after install
        opts = {
          ensure_installed = { "haskell", "supercollider" },
          highlight = { enable = true },
          indent = { enable = true },
        },
        config = function(_, opts)
          require("nvim-treesitter.configs").setup(opts)
        end,
      },
    },
  },
}

