local config = require("config")

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- Autocompletion
      { "hrsh7th/nvim-cmp" },         -- Required
      { "hrsh7th/cmp-nvim-lsp" },     -- Required
      { "hrsh7th/cmp-buffer" },       -- Optional
      { "hrsh7th/cmp-path" },         -- Optional
      { "hrsh7th/cmp-cmdline" },      -- Optional
      { "hrsh7th/cmp-nvim-lua" },     -- Optional
      { "saadparwaiz1/cmp_luasnip" }, -- Optional
      { "windwp/nvim-autopairs" },    -- Optional

      -- Snippets
      { "L3MON4D3/LuaSnip" }, -- Required
    },
    config = function()
      -- Nvim-CMP
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

      local luasnip = require("luasnip")
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
      -- `:` cmdline setup.
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" }
        }, {
          {
            name = "cmdline",
            option = {
              ignore_cmds = { "Man", "!" },
            }
          }
        })
      })
      -- `/` cmdline setup.
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' },
        }
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
    end
  }
}
