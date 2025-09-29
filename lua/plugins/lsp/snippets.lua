local luasnip = require("luasnip")

return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      luasnip.config.setup({})
      require("luasnip.loaders.from_vscode").lazy_load()

      local snippets_dir = vim.fn.stdpath("config") .. "/snippets"
      require("luasnip.loaders.from_lua").load({ paths = { snippets_dir } })
    end,
  },
  {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()

      -- HTML snippets for ReactJS
      luasnip.filetype_extend("javascriptreact", { "html" })
      luasnip.filetype_extend("javascriptreact", { "javascript" })
    end,
  },
}
