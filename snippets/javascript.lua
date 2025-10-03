local luasnip = require("luasnip")

local snip = luasnip.snippet
local ls_fmt = require("luasnip.extras.fmt").fmt
local text_node = luasnip.text_node
local insert_node = luasnip.insert_node
local function_node = luasnip.function_node

local function get_filename()
  return vim.fn.expand("%:t:r")
end

return {
  snip(
    { trig = "lambda", name = "Lambda expression" },
    ls_fmt(
      [[
      ({}) => {{ {} }}
      ]],
      { insert_node(1, "param"), insert_node(2, "action") }
    )
  ),
  snip(
    { trig = "eaf", name = "Export async function" },
    ls_fmt(
      [[
      export async function {}() {{
      }}
      ]],
      { insert_node(1, "funcName") }
    )
  ),
  snip(
    { trig = "ecl", name = "Export default class" },
    ls_fmt(
      [[
      export default class {} {{
        constructor({}) {{
        }}
      }}
      ]],
      {
        function_node(function()
          return { vim.fn.expand("%:t:r") }
        end, {}),
        insert_node(1, "param"),
      }
    )
  ),
}
