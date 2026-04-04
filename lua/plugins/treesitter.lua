vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master", -- Backward compatability for Nvim 0.11
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context", -- Optional
    },
    config = function()
      local configs = require("nvim-treesitter.configs")

      ---@diagnostic disable-next-line: missing-fields
      configs.setup({
        ensure_installed = {
          -- "html", -- WARN: Can cause `SEGV` when in insert mode
          "htmldjango",
          "css",
          "javascript",
          "typescript",
          "tsx",

          "python",
          "go",
          "java",
          "kotlin",

          "sql",

          "bash",

          "dockerfile",

          "json",
          "yaml",
          "toml",

          "markdown",
          "markdown_inline",

          "query",
          "regex",

          "lua",
          "luadoc",
          "luap",
          "vim",
        },
        sync_install = false,
        auto_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
