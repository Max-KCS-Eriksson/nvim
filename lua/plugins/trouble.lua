return {
  {
    "folke/trouble.nvim",
    opts = {
      auto_preview = false,
      focus = true,
      auto_refresh = false,
    },
    cmd = { "Trouble" },
    keys = {
      { "<leader>!!", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>!b", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>!s", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
      { "<leader>!L", "<cmd>Trouble lsp toggle<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
      { "<leader>!l", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>!q", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
  },
}
