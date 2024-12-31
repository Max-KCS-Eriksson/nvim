local config = require("config")
local icons = require("config").icons
local map = vim.keymap.set

return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" },             -- Required
      { "williamboman/mason.nvim" },           -- Optional
      { "williamboman/mason-lspconfig.nvim" }, -- Optional

      -- Java specific LSP
      { "mfussenegger/nvim-jdtls" }, -- Optional

      -- Autocompletion
      { "hrsh7th/nvim-cmp" },         -- Required
      { "hrsh7th/cmp-nvim-lsp" },     -- Required
      { "hrsh7th/cmp-buffer" },       -- Optional
      { "hrsh7th/cmp-path" },         -- Optional
      { "saadparwaiz1/cmp_luasnip" }, -- Optional
      { "hrsh7th/cmp-nvim-lua" },     -- Optional
      { "windwp/nvim-autopairs" },    -- Optional

      -- Snippets
      { "L3MON4D3/LuaSnip" },             -- Required
      { "rafamadriz/friendly-snippets" }, -- Optional

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

      -- LuaSnip
      local luasnip = require("luasnip")

      luasnip.config.setup({})
      require("luasnip.loaders.from_vscode").lazy_load()

      local snippets_dir = vim.fn.stdpath("config") .. "/snippets"
      require("luasnip.loaders.from_lua").load({ paths = { snippets_dir } })

      -- Nvim-CMP setup
      local cmp = require("cmp")

      local function get_entry_filter_function()
        return function()
          local context = require("cmp.config.context")
          return not context.in_treesitter_capture("comment")
              and not context.in_syntax_group("Comment")
              and not context.in_treesitter_capture("string")
              and not context.in_syntax_group("String")
        end
      end

      ---@diagnostic disable-next-line: missing-fields
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete({}),
          ["<Tab>"] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Insert,
          }),
          ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-p>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          {
            name = "luasnip",
            group_index = 1,
            option = { use_show_condition = true },
            entry_filter = get_entry_filter_function(),
          },
          { name = "buffer" },
          { name = "path" },
        }),
        window = {
          completion = cmp.config.window.bordered({
            border = config.window_border,
            winhighlight = "Normal:Pmenu," .. "FloatBorder:FloatBorder," .. "CursorLine:PmenuSel," .. "Search:None",
          }),
          documentation = cmp.config.window.bordered({
            border = config.window_border,
            winhighlight = "Normal:NormalFloat," .. "FloatBorder:FloatBorder," .. "Search:None",
          }),
        },
      })

      ---@diagnostic disable-next-line: missing-fields
      cmp.setup.filetype("neorg", {
        sources = cmp.config.sources({
          { name = "buffer" },
          { name = "path" },
          {
            name = "luasnip",
            group_index = 1,
            option = { use_show_condition = true },
            entry_filter = get_entry_filter_function(),
          },
          { name = "neorg" },
        }),
      })

      -- Auto pairs
      --   Insert `(` after select function or method item
      --   Don’t use `nil` to disable a filetype. If a filetype is `nil` then `*` is
      --   used as fallback.
      require("nvim-autopairs").setup({})
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local handlers = require("nvim-autopairs.completion.handlers")
      cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done({
          filetypes = {
            ["*"] = {
              ["("] = {
                kind = {
                  cmp.lsp.CompletionItemKind.Function,
                  cmp.lsp.CompletionItemKind.Method,
                },
                handler = handlers["*"],
              },
            },
            -- Disable for shellscripts
            sh = false,
            zsh = false,
          },
        })
      )

      -- Lsp UI
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
      -- LSP_Signature settings
      require("lsp_signature").setup({
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        always_trigger = true,
        -- Floating Window
        floating_window = true, -- When writing arguments
        floating_window_above_cur_line = true,
        handler_opts = {
          border = config.window_border,
        },
        -- Turn off floating window until toggle key is pressed again
        toggle_key_flip_floatwin_setting = true,
        -- Virtual hint
        hint_enable = false,
        hint_prefix = "? ",
        hint_scheme = "String",
        hint_inline = function() -- Enable inline hints (nvim 0.10 only)
          return false
        end,
        hi_parameter = "LspSignatureActiveParameter", -- Highlight group
      })
      -- NOTE: Requires toggle to show signature next time.
      map("i", "<C-k>", function()
        require("lsp_signature").toggle_float_win()
      end, { desc = "toggle signature" })
      map("i", "<C-s>", function()
        require("lsp_signature").signature({ trigger = "NextSignature" }) -- Cycle alternative signatures
      end, { desc = "select signature" })
    end,
  },
}
