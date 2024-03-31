-- Setting options
--   See `:help vim.o`
--   See `:help formatoptions` and `:help fo-table`
local o = vim.opt

o.guicursor = "n-v-sm:block,"                         -- Block in normal and visual
    .. "ci-ve:ver100,"
    .. "r-cr-o:hor20,"                                -- Underscore in replace
    .. "i-c:ver100-blinkwait700-blinkoff200-blinkon200" -- Blinking line in insert and command
    .. "-Cursor/lCursor"

o.cursorline = true
o.nu = true
o.relativenumber = true
o.foldcolumn = "1"
o.signcolumn = "yes:1"

o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true

o.smartindent = true

o.wrap = false

o.foldlevelstart = 99

o.splitright = true
o.splitbelow = true

o.swapfile = false
o.backup = false
o.undodir = { os.getenv("XDG_STATE_HOME") .. "/nvim/undo/" } -- Undotree access
o.undofile = true                                            -- Save undo history

o.hlsearch = true                                            -- `:noh` clears the highlighting
o.incsearch = true                                           -- Lower-case search match upper-case

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true

o.termguicolors = true

o.scrolloff = 8 -- Don't scroll cursor to top/bottom unless at the very top/end.
o.isfname:append("@-@")

o.updatetime = 50

o.colorcolumn = "81" -- Vertical ruler

-- Sync clipboard between OS and Neovim.
--   Remove this option if you want your OS clipboard to remain independent.
--   See `:help 'clipboard'`
o.clipboard = "unnamedplus"

o.list = true
