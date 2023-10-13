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
        window = {
          border = defaults.window_border,
        },
      })
      wk.register({
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader>"] = {
          name = "+leader",
          ["!"] = { name = "+diagnostics/quickfixes" },
          ["f"] = {
            name = "+find",
            ["!"] = { name = "+diagnostics/todo" },
          },
          ["o"] = { name = "+open" },
          ["t"] = { name = "+toggle" },
          ["s"] = { name = "+split" },
          ["l"] = { name = "+list" },
        },
      })
    end,
  },
}
