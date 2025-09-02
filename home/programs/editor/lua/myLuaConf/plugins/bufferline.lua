return {
  "bufferline-nvim",
  lazy = false,
  load = function(name)
    vim.cmd.packadd("bufferline-nvim")
    vim.cmd.packadd("nvim-web-devicons")
  end,
  after = function()
    require("bufferline").setup({
      options = {
        diagnostics = "nvim_lsp",
        offsets = {
          { filetype = "neo-tree", text = "Explorer", text_align = "left" }
        },
      },
    })
    -- Example buffer switching keymaps
    vim.keymap.set("n", "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>")
    vim.keymap.set("n", "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>")
  end,
}

