local colors = require("gruvbox-baby.colors").config(require("gruvbox-baby.config"))
local map = vim.keymap.set

local exclude_ft = { -- Exclude these filetypes
  "gitcommit",
}

return {
  "folke/twilight.nvim",
  opts = {
    dimming = {
      alpha = 0.25,                -- Amount of dimming
      color = { "Normal", colors.foreground },
      term_bg = colors.background, -- If guibg=NONE, this will be used to calculate text color
      inactive = false,            -- When true, other windows will be fully dimmed (unless they contain the same buffer)
    },
    context = 10,                  -- Amount of lines we will try to show around the current line
    treesitter = true,             -- Use treesitter when available for the filetype
    -- Treesitter is used to automatically expand the visible text,
    -- But you can further control the types of nodes that should always be fully expanded
    expand = { -- For treesitter, we we always try to expand to the top-most ancestor with these types
      "function",
      "method",
      "table",
      "if_statement",
    },
    exclude = exclude_ft, -- Exclude these filetypes,
  },
  config = function()
    map("n", "<leader>tz", ":Twilight<cr>", { desc = "Twilight - dim inactive portions of the code" })

    -- Toggle Twilight by default
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
      pattern = "*",
      group = vim.api.nvim_create_augroup("auto_toggle_twilight", { clear = true }),
      callback = function()
        local toggle_twilight = true
        for i, ft in ipairs(exclude_ft) do
          if ft == vim.bo.ft then
            vim.cmd("TwilightDisable")
            toggle_twilight = false
          end
        end
        if toggle_twilight then
          vim.cmd("TwilightEnable")
        end
      end,
    })
  end,
}
