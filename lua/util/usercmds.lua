-- List luasnip snippets
-- NOTE: Credit to https://github.com/gennaro-tedesco
-- https://github.com/gennaro-tedesco/dotfiles/blob/185bf9ab6a33c700739abf2ba429babe05c0dbe3/nvim/lua/plugins/snip.lua#L216-L225
local list_snips = function()
  local ft_list = require("luasnip").available()[vim.o.filetype]
  local ft_snips = {}
  for _, item in pairs(ft_list) do
    ft_snips[item.trigger] = item.name
  end
  print(vim.inspect(ft_snips))
end

vim.api.nvim_create_user_command("SnipList", list_snips, {})
