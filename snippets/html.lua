local luasnip = require("luasnip")

local snip = luasnip.snippet
local ls_fmt = require("luasnip.extras.fmt").fmt
local text_node = luasnip.text_node
local insert_node = luasnip.insert_node
local function_node = luasnip.function_node

return {
  snip(
    { trig = "thymeleaf", name = "Add Thymeleaf template engine tag" },
    ls_fmt(
      [[
        <html lang="en" xmlns:th="https://www.thymeleaf.org">
      ]],
      {}
    )
  ),
}
