local config = require("config")

return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signs_staged = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signs_staged_enable = true,
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        max_file_length = 40000,
        preview_config = {
          -- Options passed to nvim_open_win
          border = config.window_border,
          style = "minimal",
          row = 0,
          col = 1,
        },
      })

      -- Highlights
      -- The highlights `GitSigns[kind][type]` is used for each kind of sign. E.g.
      -- 'add' signs uses the highlights:
      --   • `GitSignsAdd`   (for normal text signs)
      --   • `GitSignsAddNr` (for signs when `config.numhl == true`)
      --   • `GitSignsAddLn `(for signs when `config.linehl == true`)
      --   • `GitSignsAddCul `(for signs when `config.culhl == true`)
    end,
  },
}
