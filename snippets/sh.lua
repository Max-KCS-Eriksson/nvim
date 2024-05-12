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
  --           do the thing...
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
    { trig = "yn", name = "Process yes/no question" },
    ls_fmt(
      [[
      read -p "{}: " yn
      case $yn in
      [Yy]*)
          break
          ;;
      [Nn]*)
          break
          ;;
      *)
          ;;
      esac
      ]],
      { insert_node(1, "prompt_message") }
    )
  ),
  snip({ trig = "here", name = "Parent dir of executed script" }, ls_fmt("$(dirname $0)", {})),
}
