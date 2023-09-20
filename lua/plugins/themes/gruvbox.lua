return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      local config = require("gruvbox").config
      local colors = require("gruvbox.palette").get_base_colors(vim.o.background, config.contrast)
      require("gruvbox").setup({
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = false,
          comments = true,
          operators = false,
          folds = true,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true, -- invert background for search, diffs, statuslines and errors
        contrast = "", -- can be "hard", "soft" or empty string
        palette_overrides = {},
        overrides = {
          -- Override color for specific groups.
          -- See groups in source code:
          -- https://github.com/ellisonleao/gruvbox.nvim/blob/main/lua/gruvbox/groups.lua

          -- Workspace
          FoldColumn = { bg = colors.bg0 },
          SignColumn = { bg = colors.bg0 },
          GruvboxRedSign = {
            bg = colors.bg0,
            fg = colors.red,
            reverse = config.invert_signs,
          },
          GruvboxGreenSign = {
            bg = colors.bg0,
            fg = colors.green,
            reverse = config.invert_signs,
          },
          GruvboxYellowSign = {
            bg = colors.bg0,
            fg = colors.yellow,
            reverse = config.invert_signs,
          },
          GruvboxBlueSign = {
            bg = colors.bg0,
            fg = colors.blue,
            reverse = config.invert_signs,
          },
          GruvboxPurpleSign = {
            bg = colors.bg0,
            fg = colors.purple,
            reverse = config.invert_signs,
          },
          GruvboxAquaSign = {
            bg = colors.bg0,
            fg = colors.aqua,
            reverse = config.invert_signs,
          },
          GruvboxOrangeSign = {
            bg = colors.bg0,
            fg = colors.orange,
            reverse = config.invert_signs,
          },
          -- Syntax
          Include = { fg = colors.red },
          Function = { fg = colors.aqua },
          Operator = { fg = colors.aqua },
          Constant = { fg = colors.purple, bold = true },
        },
        dim_inactive = true,
        transparent_mode = false,
      })

      -- Use above settings
      vim.cmd.colorscheme("gruvbox")
      vim.o.background = "dark"

      -- Color line numbers
      -- Absolute line numbers
      vim.api.nvim_set_hl(0, "LineNR", { fg = colors.aqua })
      -- Relative line numbers
      vim.api.nvim_set_hl(0, "LineNrAbove", { fg = colors.bg4 })
      vim.api.nvim_set_hl(0, "LineNrBelow", { fg = colors.bg4 })

      -- Vim-illuminate
      vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = colors.bg2 })
      vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = colors.bg2 })
      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = colors.bg2 })
    end,
  },
}
