local icons = require("config").icons

return {
  {
    "folke/todo-comments.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- Required
      "nvim-telescope/telescope.nvim", -- Optional
    },
    config = function()
      local colors = require("gruvbox-baby.colors").config(require("gruvbox-baby.config"))

      require("todo-comments").setup({
        signs = false, -- Icons in signcolumn
        -- Keywords recognized as todo-comments
        keywords = {
          FIX = {
            icon = icons.todo.FIX,
            color = "error",                            -- Can be a hex color, or a named color (see docs). Affects signcolumn
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- Keyword variants
            signs = true,                               -- Signs for individual keywords
          },
          TODO = { icon = icons.todo.TODO, color = colors.orange },
          HACK = { icon = icons.todo.HACK, color = "warning" },
          WARN = {
            icon = icons.todo.WARN,
            color = "warning",
            alt = { "WARNING", "XXX" },
          },
          PERF = {
            icon = icons.todo.PERF,
            alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
          },
          NOTE = { icon = icons.todo.NOTE, color = "hint", alt = { "INFO" } },
          TEST = {
            icon = icons.todo.TEST,
            color = "test",
            alt = { "TESTING", "PASSED", "FAILED" },
          },
        },
      })

      -- Keymaps
      local map = vim.keymap.set
      local todo_comment = require("todo-comments")

      -- Telescope finder
      local util = require("util")

      local keywords = "TODO,FIX,FIXME,BUG,HACK"

      -- HACK: Copied function from source as function is not exposed:
      -- https://github.com/folke/todo-comments.nvim/commit/7420337c20d766e73eb83b5d17b4ef50331ed4cd#diff-eef0c3016ae04a2ee50758d4eb50210cc1cb091780520c6543ab8dc3cf4ba3d7R24-L65
      -- Hardcoded values are put in place of calls to `Config.*`
      local function get_opts(keywords_string)
        keywords = vim.split(keywords_string, ",")

        local Config = require("todo-comments.config")
        local Highlight = require("todo-comments.highlight")
        local make_entry = require("telescope.make_entry")

        local opts = {}
        opts.vimgrep_arguments = { "rg" }
        vim.list_extend(opts.vimgrep_arguments, {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
        })

        local function tags(words)
          local kws = words
          table.sort(kws, function(a, b)
            return #b < #a
          end)
          return table.concat(kws, "|")
        end

        local function search_regex(searchwords)
          local pattern = [[\b(KEYWORDS):]] -- ripgrep regex
          return pattern:gsub("KEYWORDS", tags(searchwords))
        end

        opts.search = search_regex(keywords)
        opts.prompt_title = "Find Todo"
        opts.use_regex = true
        local entry_maker = make_entry.gen_from_vimgrep(opts)
        opts.entry_maker = function(line)
          local ret = entry_maker(line)
          ret.display = function(entry)
            local display = string.format("%s:%s:%s ", entry.filename, entry.lnum, entry.col)
            local text = entry.text
            local start, finish, kw = Highlight.match(text)
            local hl = {}
            if start then
              kw = Config.keywords[kw] or kw
              local icon = Config.options.keywords[kw].icon
              display = icon .. " " .. display
              table.insert(hl, { { 1, #icon + 1 }, "TodoFg" .. kw })
              text = vim.trim(text:sub(start))
              table.insert(hl, {
                { #display, #display + finish - start + 2 },
                "TodoBg" .. kw,
              })
              table.insert(hl, {
                { #display + finish - start + 1, #display + finish + 1 + #text },
                "TodoFg" .. kw,
              })
              display = display .. " " .. text
            end
            return display, hl
          end
          return ret
        end
        return opts
      end

      map("n", "<leader>f!c", util.telescope("grep_string", get_opts(keywords)), { desc = "Todo comments" })
      map("n", "]t", function()
        todo_comment.jump_next()
      end, { desc = "Next todo comment" })
      map("n", "[t", function()
        todo_comment.jump_prev()
      end, { desc = "Previous todo comment" })
    end,
  },
}
