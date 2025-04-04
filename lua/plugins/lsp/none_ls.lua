local config = require("config")
local icons = require("config").icons

return {
  -- Autoinstall linters and diagnostic tools used by `none-ls`.
  "jay-babu/mason-null-ls.nvim",
  dependencies = {
    { -- Linting and diagnostics
      "nvimtools/none-ls.nvim",
      dependencies = { "nvimtools/none-ls-extras.nvim" },
    },
    { "williamboman/mason.nvim" },
    { "nvim-lua/plenary.nvim" },
  },
  config = function()
    -- Mason config
    require("mason").setup({
      ui = {
        border = config.window_border,
        icons = {
          package_installed = icons.mason.Installed,
          package_pending = icons.mason.Pending,
          package_uninstalled = icons.mason.Uninstalled,
        },
      },
    })

    -- Primary Source of Truth is none-ls
    -- Automatically install sources, but require manual config.
    local null_ls = require("null-ls") -- none-ls is drop in replacement for null-ls
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    local builtins = null_ls.builtins
    null_ls.setup({
      border = config.window_border,
      diagnostic_config = {
        underline = config.diagnostic.options.underline,
        virtual_text = config.diagnostic.options.virtual_text,
        signs = config.diagnostic.options.signs,
      },
      diagnostics_format = config.diagnostic.format,
      -- Listed sources will be automatically installed by `mason-null-ls`.
      sources = {
        -- Shell script
        require("none-ls.formatting.beautysh").with({ -- multiple shell languages
          filetypes = { "zsh" },
        }),
        builtins.formatting.shellharden, -- bash only
        builtins.formatting.shfmt.with({ -- bash only
          extra_args = { "--indent", "4" },
        }),

        -- Lua
        builtins.formatting.stylua,

        -- Python
        require("none-ls.diagnostics.flake8").with({
          extra_args = { "--max-line-length", "88", "--ignore=F401,E999,W503,E124" },
        }),
        builtins.formatting.isort,
        builtins.formatting.black,

        -- Django
        builtins.diagnostics.djlint.with({
          extra_args = { "--ignore", "H006", "H031" },
        }),
        builtins.formatting.djlint,

        -- Go
        builtins.diagnostics.golangci_lint,
        builtins.formatting.gofumpt,

        -- JS & TS
        require("none-ls.diagnostics.eslint_d"),
        builtins.formatting.prettier.with({
          extra_args = { "--single-quote", "false", "--tab-width", "4" },
        }),

        -- Java
        builtins.formatting.google_java_format.with({
          extra_args = { "--aosp" }, -- Indent 4 instead of 2
        }),

        -- Kotlin
        builtins.diagnostics.ktlint,
        builtins.formatting.ktlint,

        -- Docker
        builtins.diagnostics.hadolint,

        -- Spelling
        builtins.diagnostics.codespell,
      },
      -- Sync Formatting
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end,
    })

    require("mason-null-ls").setup({
      ensure_installed = nil,
      automatic_installation = true,
      automatic_setup = false,
    })
  end,
}
