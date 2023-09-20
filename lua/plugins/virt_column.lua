return {
  {
    "lukas-reineke/virt-column.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("virt-column").setup({ char = "│" }) -- Suggestions: '▕', '│'
    end,
  },
}
