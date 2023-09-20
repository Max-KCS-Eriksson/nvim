local map = vim.keymap.set

return {
  {
    "folke/trouble.nvim",
    opts = {
      auto_preview = false,
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- Keymaps
      map("n", "<leader>!!", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true, desc = "Trouble" })
      map(
        "n",
        "<leader>!w",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        { silent = true, noremap = true, desc = "Trouble workspace" }
      )
      map(
        "n",
        "<leader>!d",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        { silent = true, noremap = true, desc = "Trouble document" }
      )
      map(
        "n",
        "<leader>!l",
        "<cmd>TroubleToggle loclist<cr>",
        { silent = true, noremap = true, desc = "Trouble local" }
      )
      map(
        "n",
        "<leader>!q",
        "<cmd>TroubleToggle quickfix<cr>",
        { silent = true, noremap = true, desc = "Trouble quickfix" }
      )
      map(
        "n",
        "<leader>!r",
        "<cmd>TroubleToggle lsp_references<cr>",
        { silent = true, noremap = true, desc = "Trouble LSP references" }
      )
    end,
  },
}
