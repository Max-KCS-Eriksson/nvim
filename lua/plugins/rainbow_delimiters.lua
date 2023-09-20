return {
  {
    "hiphish/rainbow-delimiters.nvim",
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],

          -- Disable for filetypes
          html = rainbow_delimiters.strategy["noop"],
          htmldjango = rainbow_delimiters.strategy["noop"],
          markdown = rainbow_delimiters.strategy["noop"],
          markdown_inline = rainbow_delimiters.strategy["noop"],
        },
        -- Which query to use for finding delimiters
        query = {
          [""] = "rainbow-delimiters",
        },
        highlight = {
          "RainbowDelimiterViolet",
          "RainbowDelimiterBlue",
          "RainbowDelimiterCyan",
          "RainbowDelimiterGreen",
          "RainbowDelimiterYellow",
          "RainbowDelimiterOrange",
        },
      }
    end,
  },
}
