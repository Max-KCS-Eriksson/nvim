-- BUG: Stylua doesn't work expectedly when using these
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
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      char = "▏", -- Suggestions: '|', '¦', '┆', '┊', '┃', '║', '▏'
      filetype_exclude = filetype_exclude,
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },

  -- Active indent guide and indent text objects
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      symbol = "▏", -- Suggestions: '|', '¦', '┆', '┊', '┃', '║', '▏'
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
