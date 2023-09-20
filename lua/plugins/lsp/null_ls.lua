local config = require("config")
local icons = require("config").icons

return {
  -- Autoinstall linters and diagnostic tools used by `null-ls`.
  "jay-babu/mason-null-ls.nvim",
  dependencies = {
    { "jose-elias-alvarez/null-ls.nvim" }, -- Linting and diagnostics
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

    -- Primary Source of Truth is null-ls
    -- Automatically install sources, but require manual config.
    local null_ls = require("null-ls")
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics
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
        formatting.beautysh.with({ -- multiple shell languages
          filetypes = { "zsh" },
        }),
        diagnostics.shellcheck, -- bash only
        formatting.shellharden, -- bash only
        formatting.shfmt.with({ -- bash only
          extra_args = { "--indent", "4" },
        }),

        -- Lua
        diagnostics.luacheck,
        formatting.stylua,

        -- Python
        diagnostics.flake8.with({
          extra_args = { "--max-line-length", "88", "--ignore=F401,E999,W503,E124" },
        }),
        formatting.isort,
        formatting.black,

        -- Django
        diagnostics.djlint.with({
          extra_args = { "--ignore", "H006", "H031" },
        }),
        formatting.djlint,

        -- Go
        diagnostics.golangci_lint,
        formatting.gofumpt,

        -- JS & TS
        diagnostics.eslint_d,
        formatting.prettier.with({
          extra_args = { "--single-quote", "false" },
        }),

        -- Java
        formatting.google_java_format.with({
          extra_args = { "--aosp" },
        }),

        -- Kotlin
        diagnostics.ktlint,
        formatting.ktlint,

        -- Docker
        diagnostics.hadolint,

        -- Spelling
        diagnostics.misspell,
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
