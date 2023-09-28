local map = vim.keymap.set

return {
  {
    "mbbill/undotree",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      map("n", "<leader>tu", vim.cmd.UndotreeToggle, { desc = "Undotree" })
    end,
  },
}
