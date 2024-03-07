local indent_char = require("config").indent_char
local filetype_exclude = {
  "help",
  "alpha",
  "dashboard",
  "neo-tree",
  "Trouble",
  "lazy",
  "mason",
  "neorg",
}

return {
  -- Indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("ibl").setup({
        indent = {
          char = indent_char,
          highlight = "IndentChar",
        },
        exclude = {
          filetypes = filetype_exclude,
        },
        scope = { enabled = false },
      })
    end,
  },

  -- Active indent guide and indent text objects
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      symbol = indent_char,
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = filetype_exclude,
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
    config = function(_, opts)
      require("mini.indentscope").setup(opts)
    end,
  },
}
