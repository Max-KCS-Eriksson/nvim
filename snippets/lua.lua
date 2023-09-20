local luasnip = require("luasnip")

local snip = luasnip.snippet
local ls_fmt = require("luasnip.extras.fmt").fmt
local text_node = luasnip.text_node
local insert_node = luasnip.insert_node
local function_node = luasnip.function_node

return {
  -- Example snippets:
  -- filetype = { -- Name of the filetype
  --   snip(
  --   -- What will trigger the snippet, and its name.
  --     { trig = "triggering keys", name = "snippet name" },
  --     -- The actual snippet
  --     ls_fmt(
  --       [[
  --       function {}({}) -- Insert nodes are defined as `{}` in the snippet.
  --           stuff ..    -- Escape insert_node with `{{}}`
  --       end
  --       ]],
  --       { insert_node(1, "placeholder"), insert_node(2, "other placeholder") }
  --     )
  --   ),
  --   snip(
  --     { trig = "foo", name = "bar" },
  --     ls_fmt(
  --       "Lorem ipsum dolor sit amet, qui minim labore adipisicing minim...",
  --       {} -- Positional param taking a table
  --     )
  --   ),
  -- },

  -- Snippets
  snip(
    { trig = "split", name = "Split sting on delimiter" },
    ls_fmt(
      [[
      function split(string, sep)
        local fields = {{}}

        local _sep = sep or " "
        local pattern = string.format("([^%s]+)", _sep)
        string.gsub(string, pattern, function(c)
          fields[#fields + 1] = c
        end)

        return fields
      end
      ]],
      {}
    )
  ),
}
