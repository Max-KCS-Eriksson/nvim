return {
  {
    "zbirenbaum/neodim",
    event = "LspAttach",
    enabled = false, -- BUG: Breaks updating of syntax highlighting on insert
    config = function()
      local background_color = require("gruvbox-baby.colors").config().background
      require("neodim").setup({
        alpha = 0.60,
        blend_color = background_color,
        update_in_insert = {
          enable = true,
          delay = 100,
        },
        hide = {
          virtual_text = true,
          signs = false,
          underline = true,
        },
      })
    end,
  },
}
