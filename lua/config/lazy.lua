-- Bootstrap lazy.nvim
-- Ensures the plugin manager is installed.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local config = require("config")

-- Manage plugins
require("lazy").setup({
  spec = {
    -- All lua files in the directory specified in `{ import = "path/to/dir" }` will
    -- automatically be merged into the plugin spec.
    { import = "plugins" },
    { import = "plugins/lsp" },
  },
  install = {
    colorscheme = { config.colorscheme },
  },
  ui = {
    border = config.window_border,
  },
})
