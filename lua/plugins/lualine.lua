local icons = require("config").icons

vim.opt.showmode = false

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = function(plugin)
      return {
        options = {
          component_separators = "|", -- Suggestions: { left = "", right = ""}, "|"
          section_separators = "", -- Suggestions: { left = "", right = ""}, ""
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard", "lazy", "alpha" } },
          theme = function()
            local colors = require("gruvbox-baby.colors").config(require("gruvbox-baby.config"))

            return {
              normal = {
                a = { bg = colors.milk, fg = colors.dark, gui = "bold" },
                b = { bg = colors.medium_gray, fg = colors.milk },
                c = { bg = colors.background, fg = colors.milk },
              },
              insert = {
                a = { bg = colors.primary, fg = colors.dark, gui = "bold" },
                b = { bg = colors.medium_gray, fg = colors.milk },
                c = { bg = colors.background, fg = colors.milk },
              },
              visual = {
                a = { bg = colors.secondary, fg = colors.dark, gui = "bold" },
                b = { bg = colors.medium_gray, fg = colors.milk },
                c = { bg = colors.background, fg = colors.milk },
              },
              replace = {
                a = { bg = colors.red, fg = colors.dark, gui = "bold" },
                b = { bg = colors.medium_gray, fg = colors.milk },
                c = { bg = colors.background, fg = colors.milk },
              },
              command = {
                a = { bg = colors.clean_green, fg = colors.dark, gui = "bold" },
                b = { bg = colors.medium_gray, fg = colors.milk },
                c = { bg = colors.background, fg = colors.milk },
              },
              inactive = {
                a = { bg = colors.gray, fg = colors.milk, gui = "bold" },
                b = { bg = colors.medium_gray, fg = colors.milk },
                c = { bg = colors.background, fg = colors.milk },
              },
            }
          end,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            {
              "diff",
              symbols = {
                added = icons.git.Added,
                modified = icons.git.Modified,
                removed = icons.git.Removed,
              },
            },
            {
              "filetype",
              icon_only = true,
              separator = "",
              padding = {
                left = 1,
                right = 0,
              },
            },
            {
              "filename",
              path = 1,
              symbols = {
                modified = icons.current_buffer.modified,
                readonly = icons.current_buffer.readonly,
                unnamed = icons.current_buffer.unnamed,
              },
            },
          },
          lualine_x = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.error.Icon,
                warn = icons.diagnostics.warn.Icon,
                info = icons.diagnostics.info.Icon,
                hint = icons.diagnostics.hint.Icon,
              },
            },
            {
              -- Display active LSP
              function()
                for _, client in ipairs(vim.lsp.get_clients()) do
                  if client.name ~= "null-ls" then
                    return client.name
                  end
                end
              end,
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 1 } },
          },
          lualine_z = {
            { "location", padding = { left = 1, right = 1 } },
          },
        },
        inactive_sections = {},
        winbar = {},
        inactive_winbar = {},
      }
    end,
  },
}
