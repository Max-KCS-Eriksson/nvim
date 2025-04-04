local defaults = require("config")

return {
  {
    "folke/which-key.nvim",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      triggers = {
        "<leader>",
        "<localleader>",
      },
    },
    config = function()
      local wk = require("which-key")
      wk.setup({
        win = { border = defaults.window_border },
        icons = {
          keys = {
            C = "<C>",
            M = "<A>",
            Tab = "<Tab>",
          },
        },
      })
      wk.add({
        {
          mode = { "n", "v" },
          { "g", group = "+goto" },
          { "]", group = "+next" },
          { "[", group = "+prev" },
          { "<leader>", group = "+leader" },
          { "<leader>!", group = "+diagnostics/quickfixes" },
          { "<leader>f", group = "+find" },
          { "<leader>f!", group = "+diagnostics/todo" },
          { "<leader>o", group = "+open" },
          { "<leader>t", group = "+toggle" },
          { "<leader>s", group = "+split/swap" },
          { "<leader>l", group = "+list" },
          { '<leader>"', group = "+copy" },
        },
      })
    end,
  },
}
