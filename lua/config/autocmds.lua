local function augroup(name)
  return vim.api.nvim_create_augroup("augroup_" .. name, { clear = true })
end

-- Active window options
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "VimEnter" }, {
  group = augroup("active_win_opts"),
  callback = function()
    vim.opt_local.cursorline = true
  end,
})

-- Inactive window options
vim.api.nvim_create_autocmd("WinLeave", {
  group = augroup("inactive_win_opts"),
  callback = function()
    vim.opt_local.cursorline = false
    vim.api.nvim_set_hl(0, "LineNR", { link = "InactiveLineNR" })
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

-- Highlight on yank
--   See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Go to last location when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    if vim.bo.ft == "help" then
      -- HACK: Help buffer MUST be closed with `:bd` rather than `:q` to open in
      -- vertical split (using below autocmd) the next time.
      vim.keymap.set("n", "q", "<cmd>bd<cr>", { buffer = event.buf, silent = true })
    else
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end
  end,
})

-- Wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Always open help and man in vertical split
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("vertical_help"),
  pattern = {
    "help",
    "man",
  },
  callback = function()
    vim.cmd.wincmd("L")
  end,
})

-- Set formatoptions for all filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("global_formatoptions"),
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove("o")
  end,
})

-- Turn off Caps Lock when leaving insert or cmd mode
-- NOTE: External requirements:
--   xorg xset xdotool
vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineLeave" }, {
  group = augroup("auto_no_capslock"),
  callback = function()
    -- Check with `xset` if Caps Lock is on
    local _, _, caps_state = vim.fn.system("xset -q"):find("00: Caps Lock:%s+(%a+)")

    if caps_state == "on" then
      vim.fn.system("xdotool key Caps_Lock")
    end
  end,
})

-- Auto mkdir
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
  callback = function(context)
    local dir = vim.fn.fnamemodify(context.file, ":p:h")
    vim.fn.mkdir(dir, "p")
  end,
})

-- Neorg concealer workaround
-- HACK: Manually setting `conceallevel` to conceal links properly.
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.norg" },
  group = vim.api.nvim_create_augroup("neorg_link_concealer_hack", { clear = true }),
  command = "set conceallevel=3",
})

-- Neorg foldmethod workaround
-- HACK: Manually setting `foldmethod` to enable manual folding through VISUAL and VISUAL LINE mode.
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.norg" },
  group = vim.api.nvim_create_augroup("neorg_foldmethod_hack", { clear = true }),
  command = "set foldmethod=manual",
})

-- Neorg auto inject metadata in new note
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = { "*.norg" },
  group = vim.api.nvim_create_augroup("neorg_new_note_metadata_injection", { clear = true }),
  callback = function()
    if vim.fn.expand("%:t") == "index.norg" then
      return
    end
    local metagen = require("neorg.modules.core.esupports.metagen.module").public
    metagen.inject_metadata(vim.api.nvim_get_current_buf(), true)
  end,
})

-- Turn off diagnostics for .env files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = ".env",
  group = vim.api.nvim_create_augroup("dotenv_disabled_diagnostics", { clear = true }),
  callback = function(context)
    vim.diagnostic.disable(context.buf)
  end,
})
