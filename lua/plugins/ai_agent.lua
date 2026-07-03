local default_agent = "codex"

return {
  {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "codecompanion" },
      },
    },
    opts = {
      interactions = {
        cli = {
          agent = default_agent,

          agents = {
            codex = {
              cmd = "codex",
              args = {},
              description = "OpenAI Codex CLI",
              provider = "terminal",
            },
          },

          opts = {
            auto_insert = true,
            reload = true,
          },
        },
      },
    },
    keys = {
      {
        "<leader>aa",
        "<cmd>CodeCompanionActions<cr>",
        desc = "CodeCompanion actions",
      },
      {
        "<leader>ac",
        "<cmd>CodeCompanionChat Toggle<cr>",
        desc = "Toggle CodeCompanion chat",
      },
      {
        "<leader>ai",
        "<cmd>CodeCompanion<cr>",
        mode = { "n", "v" },
        desc = "CodeCompanion inline",
      },
      {
        "<leader>at",
        function()
          require("codecompanion").toggle_cli({ agent = default_agent })
        end,
        desc = "Toggle Codex CLI",
      },
    },
  },
}
