return {
  -- Note taking
  -- See below link for specifications on usage, or simply `:h neorg`.
  -- https://github.com/nvim-neorg/norg-specs/blob/main/1.0-specification.norg
  {
    "nvim-neorg/neorg",
    run = ":Neorg sync-parsers",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-cmp",
    },
    cmd = "Neorg",
    ft = "norg",
    config = function()
      local neorg_home = require("config").neorg.home
      local workspaces = require("config").neorg.workspaces
      local default_workspace = require("config").neorg.default_workspace
      local icon_presets = require("config").neorg.concealer.icon_presets

      -- Neorg takes care of the workspaces, but not a commom root dir
      local ensure_dir_exists = require("util").ensure_dir_exists
      ensure_dir_exists(neorg_home)

      local modules = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.dirman"] = { -- Neorg workspaces
          config = {
            workspaces = workspaces,
            default_workspace = default_workspace,
          },
        },
        ["core.concealer"] = { -- Show icons as you edit
          config = {
            folds = true,
            icon_preset = icon_presets.diamond,
            icons = {
              todo = {
                pending = { icon = "" },
                on_hold = { icon = "" },
              },
            },
          },
        },
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
            name = "Neorg",
          },
        },
        ["core.summary"] = { config = { strategy = "default" } },
        ["core.export.markdown"] = {}, -- Convert to markdown files
        ["core.qol.toc"] = { config = { close_after_use = true } },
        ["core.keybinds"] = {
          config = {
            hook = function(keybinds)
              local function cmd(neorg_cmd)
                return "<cmd>Neorg " .. neorg_cmd .. "<cr>"
              end

              keybinds.map("norg", "n", "<localleader>ee", cmd("return"), { desc = "Exit Neorg" })
              keybinds.map("norg", "n", "<localleader>et", cmd("toc"), { desc = "Table of content" })
              keybinds.map("norg", "n", "<localleader>ei", cmd("index"), { desc = "Workspace index" })
              keybinds.map("norg", "n", "<localleader>im", cmd("inject-metadata"), { desc = "Inject metadata" })
              keybinds.map(
                "norg",
                "n",
                "<localleader>is",
                cmd("generate-workspace-summary"),
                { desc = "Insert summary" }
              )
            end,
          },
        },
      }
      require("neorg").setup({ load = modules })
    end,
    keys = function()
      local has_wk, wk = pcall(require, "which-key")
      if has_wk then
        wk.register({
          ["<leader>n"] = {
            name = "+neorg",
          },
          ["<localleader>"] = {
            name = "+localleader",
            ["e"] = { name = "+explore" },
            ["i"] = { name = "+insert" },
            ["l"] = { name = "+list" },
            ["m"] = { name = "+mode" },
            ["n"] = { name = "+new" },
            ["t"] = { name = "+task" },
          },
        })
      end

      local default_workspace = require("config").neorg.default_workspace

      return {
        { "<leader>nw", ":Neorg workspace ", { desc = "Change workspace" } },
        {
          "<leader>ni",
          "<cmd>Neorg workspace " .. default_workspace .. "<cr> <bar> <cmd>Neorg index<cr>",
          { desc = "Default workspace index" },
        },
      }
    end,
  },
}
