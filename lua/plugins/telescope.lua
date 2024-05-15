local map = vim.keymap.set
local util = require("util")

return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/which-key.nvim",
    },
    config = function()
      require("telescope").setup({
        defaults = {
          borderchars = require("config").borderchars,
          file_ignore_patterns = {
            "__pycache__/",
            ".git/",
            "%.class",
          },
          layout_strategy = "vertical", -- Default if `util.telescope()` isn't used
          cache_picker = {
            num_pickers = 20,
          },
        },
      })
    end,
    cmd = "Telescope",
    keys = function()
      local has_wk, wk = pcall(require, "which-key")
      if has_wk then
        wk.register({
          ["<leader>f"] = {
            name = "+find",
            ["t"] = { name = "+Telescope" },
            ["g"] = { name = "+git" },
          },
        })
      end

      return {
        -- Pickers
        {
          "<leader>ftr",
          util.telescope("resume"),
          desc = "Resume last Telescope picker",
        },
        {
          "<leader>ftp",
          util.telescope("pickers"),
          desc = "Find prev Telescope pickers",
        },

        -- Finding
        { "<leader>ff", util.telescope("find_files"), desc = "Find files" },
        {
          "<leader>fa",
          util.telescope("find_files", { hidden = true }),
          desc = "Find all files",
        },
        { "<leader>fs", util.telescope("live_grep"), desc = "Find string" },
        { "<leader>f/", util.telescope("live_grep"), desc = "Find string" }, -- Follow vim bindings convention
        {
          "<leader>fc",
          util.telescope("grep_string"),
          desc = "Find cursor string",
        },
        {
          "<leader>f*",
          util.telescope("grep_string"),
          desc = "Find cursor string",
        }, -- Follow vim bindings convention
        {
          "<leader>fb",
          util.telescope("buffers"),
          desc = "Find buffers",
        },
        {
          "<leader>f?",
          util.telescope("help_tags"),
          desc = "Find help tags",
        },

        -- Diagnostics
        {
          "<leader>f!d",
          util.telescope("diagnostics"),
          desc = "Diagnostics",
        },

        -- Suggestions
        {
          "<leader>!s",
          util.telescope("spell_suggest"),
          desc = "Spell suggest",
        },

        -- Git
        {
          "<leader>fgf",
          util.telescope("git_files"),
          desc = "Find git files",
        },
        {
          "<leader>fgc",
          util.telescope("git_commits"),
          desc = "Git commits diffs",
        },
        {
          "<leader>fgs",
          util.telescope("git_status"),
          desc = "Git status diffs",
        },
      }
    end,
  },
}
