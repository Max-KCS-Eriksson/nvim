vim.hl = vim.highlight -- Workaround for `:Inspect` bug since version 0.10.3

require("config.keymaps")
require("config.options")
require("config.autocmds")

-- Make sure to set `mapleader` before loading the plugins so mappings are correct.
require("config.lazy")
