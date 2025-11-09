local config = require("config")
local icons = require("config").icons
local map = vim.keymap.set

return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" }, -- Required
      { "williamboman/mason.nvim" }, -- Optional
      { "williamboman/mason-lspconfig.nvim" }, -- Optional

      -- Java specific LSP
      { "mfussenegger/nvim-jdtls" }, -- Optional

      -- Show function signatures as you type
      { "ray-x/lsp_signature.nvim" },
    },
    config = function()
      -- Mason
      -- Ensure LSPs are installed and setup
      require("mason").setup()
      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = {
          -- Available servers
          -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
          "html",
          "cssls",
          "ts_ls",

          "pyright",
          "gopls",
          "jdtls", -- Needed for nvim-jdtls
          "kotlin_language_server",

          "bashls",
          "dockerls",
          "sqlls",

          "jsonls",
          "yamlls",
          "lemminx",

          "lua_ls",

          "marksman",
        },
      })

      -- LSP-Zero settings
      local lsp = require("lsp-zero").preset({
        name = "minimal",
        set_lsp_keymaps = false, -- Define my own
        manage_nvim_cmp = false, -- Define my own
        suggest_lsp_servers = true,
      })

      -- LSP gutter icons
      lsp.set_sign_icons({
        error = icons.diagnostics.error.Char,
        warn = icons.diagnostics.warn.Char,
        hint = icons.diagnostics.hint.Char,
        info = icons.diagnostics.info.Char,
      })

      -- (Optional) Configure lua language server for neovim
      lsp.nvim_workspace()

      -- Pyright config
      lsp.configure("pyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "off",
            },
          },
        },
      })

      -- HTML config
      lsp.configure("html", {
        filetypes = { "html", "htmldjango" },
      })

      -- Skip specific LSP server setup
      -- Ignore jdtls in order for nvim-jdtls to have full control.
      lsp.skip_server_setup({ "jdtls" })

      lsp.setup()

      -- Diagnostic notifications
      vim.diagnostic.config({
        virtual_text = config.diagnostic.options.virtual_text,
      })

      -- Nvim-CMP, and Auto Pair setup
      require("plugins.lsp.autocompletion")

      -- LSP UI
      require("lspconfig.ui.windows").default_options.border = config.window_border
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = config.window_border,
      })
    end,
  },

  {
    -- Make lua_ls aware of the nvim lua API
    "folke/neodev.nvim",
    opts = {},
  },

  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {},
    config = function()
      local signature = require("lsp_signature")
      -- Settings
      signature.setup({
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        always_trigger = true,
        -- Floating Window
        floating_window = true, -- When writing arguments
        floating_window_above_cur_line = true,
        handler_opts = {
          border = config.window_border,
        },
        -- Turn off floating window until toggle key is pressed again
        toggle_key_flip_floatwin_setting = false,
        -- Virtual hint
        hint_enable = false,
        hint_prefix = "? ",
        hint_scheme = "String",
        hint_inline = function() -- Enable inline hints (nvim 0.10 only)
          return false
        end,
        hi_parameter = "LspSignatureActiveParameter", -- Highlight group
      })

      -- Keys
      map("i", "<C-k>", function()
        signature.toggle_float_win()
      end, { desc = "toggle signature" })
      map("i", "<C-s>", function()
        signature.signature({ trigger = "NextSignature" }) -- Cycle alternative signatures
      end, { desc = "select signature" })
    end,
  },
}
