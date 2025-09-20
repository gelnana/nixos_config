-- lua/myLuaConf/plugins/tidal.lua
return {
  {
    "tidal.nvim",
    for_cat = 'supercollider',
    ft = { "tidal" },
    after = function()
      require('tidal').setup({
        boot = {
          tidal = {
            cmd = "ghci",
            args = { "-v0" },
            enabled = true,
          },
          sclang = {
            cmd = "sclang", 
            args = {},
            enabled = true,
          },
          split = "v",
        },
        mappings = {
          send_line = { mode = { "i", "n" }, key = "<S-CR>" },
          send_visual = { mode = { "x" }, key = "<S-CR>" },
          send_block = { mode = { "i", "n", "x" }, key = "<M-CR>" },
          send_node = { mode = "n", key = "<leader><CR>" },
          send_silence = { mode = "n", key = "<leader>td" },
          send_hush = { mode = "n", key = "<leader>th" },
        },
      })
    end,
  },
}
