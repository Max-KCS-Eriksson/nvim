return {
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    event = "BufRead",
    build = "cd app && npm install",
    config = function()
      local map = vim.keymap.set
      local wk = require("which-key")
      wk.add({
        { "<leader>om", group = "+markdown" },
      })

      -- Keymaps
      -- FIX: Make local leader key only
      map("n", "<leader>omp", "<cmd>MarkdownPreview<cr>", { desc = "Markdown preview" })
      map("n", "<leader>oms", "<cmd>MarkdownPreviewStop<cr>", { desc = "Stop markdown preview" })
    end,
  },
}
