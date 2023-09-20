local map = vim.keymap.set

return {
  {
    "terrortylor/nvim-comment",
    config = function()
      require("nvim_comment").setup({
        comment_empty = false,
        create_mappings = false,
      })

      -- Keymaps
      map("n", "<leader>tc", ":CommentToggle<cr>", { desc = "(Un)Comment line" })
      map("v", "<leader>tc", ":'<,'>CommentToggle<cr>", { desc = "(Un)Comment visual selection" })
    end,
  },
}
