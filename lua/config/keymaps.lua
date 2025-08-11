vim.g.mapleader = " "
vim.g.maplocalleader = ","

local map = vim.keymap.set
local config = require("config")

-- Quality of life bindings
map("n", "<leader>e", vim.cmd.Ex, { desc = "Netrw" })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Write" })
map("n", "<leader>W", "<cmd>noa w<cr>", { desc = "WRITE without autocmd" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all" })

map("n", "<leader><leader>", "<C-6>", { desc = "Jump to previous buffer" }) -- <C-6> should be the same as <C-^>
map("n", "<A-Tab>", "<C-w>w", { desc = "Switch windows" })
map("n", "<leader><Tab>", "<C-w>w", { desc = "Switch windows" })
map("n", "<leader>sv", "<C-w>v", { desc = "Split vertically" })
map("n", "<leader>ss", "<C-w>v", { desc = "Split side" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split horizontally" })

map("n", "zfs", "<cmd>normal ^[izf]i+<cr>", { desc = "Fold scope to bottom" })
map("n", "zfm", "<cmd>normal ^[izf]i+]mzt<cr>", { desc = "Fold method" })

map("n", "<leader>sw", "<cmd>normal yiwwviwpbbviwp<cr>", { desc = "Swap words" })
map("n", "<leader>sW", "<cmd>normal yiWWviWpbbviWp<cr>", { desc = "Swap WORDS" })

map("n", '<leader>"f', "<cmd>let @+ = expand('%:t')<cr>", { desc = "File name to system clipboard" })
map("n", '<leader>"F', "<cmd>let @+ = expand('%:p')<cr>", { desc = "Full path/to/file to system clipboard" })

-- Clear search highlight
map({ "n", "i", "v" }, "<esc>", "<esc><cmd>noh<cr>", { desc = "Clear search highlight" })
map("n", "v", "<cmd>noh<cr>v", { desc = "Clear search highlight when entering Visual" })
map("n", "V", "<cmd>noh<cr>V", { desc = "Clear search highlight when entering V-Line" })

-- Spawn another terminal
map("n", "<leader>tt", function()
  -- HACK: Requires a `_termCmd` environmental variable to be set, containing the shell
  -- command to spawn a terminal emulator with a specified working directory.
  --
  -- Below shell command can be used to get the name of the used terminal emulator:
  -- `$ basename "/""$(ps -o cmd -f -p "$(cat /proc/"$$"/stat | cut -d \  -f 4)" | tail -1 | sed 's/ .*$//')")`

  local cmd = os.getenv("_termCmd") -- Set in shell config
  local cwd = os.getenv("PWD")
  os.execute(cmd .. cwd)
end, { desc = "Terminal in CWD" })

-- Open personal project notes
map("n", "<leader>on", function()
  local util = require("util")
  local cwd = os.getenv("PWD")
  local note_file = cwd .. "/notes.norg"

  if not util.open_existing_writable(note_file) then
    local git_root = util.get_git_root()
    if git_root then
      note_file = git_root .. "/notes.norg"
      if not util.open_existing_writable(note_file) then
        print("notes.norg not found in " .. git_root)
      end
    else
      print("notes.norg not found in " .. cwd)
    end
  end
end, { desc = "Open root/dir/notes.norg file" })

-- Move blocks of code in visual mode
map("v", "J", ":m'>+1<CR>gv=gv", { desc = "Move block down" })
map("v", "K", ":m'<-2<CR>gv=gv", { desc = "Move block up" })

-- Makes * and # work in visual mode like in normal mode
vim.api.nvim_exec(
  [[
  function! g:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
  endfunction

  xnoremap * :<C-u>call g:VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
  xnoremap # :<C-u>call g:VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
]],
  false
)

-- LSP
map("n", "<leader>!f", function()
  vim.diagnostic.open_float({ border = config.window_border })
end, { desc = "Open float" })
map("n", "[d", function()
  vim.diagnostic.goto_prev({ float = { border = config.window_border } })
end, { desc = "Previous diagnostic" })
map("n", "]d", function()
  vim.diagnostic.goto_next({ float = { border = config.window_border } })
end, { desc = "Next diagnostic" })

-- Requires a language server to be attached
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local util = require("util")
    local opts = util.opts
    local _opts = { buffer = ev.buf }

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    map("n", "K", function()
      vim.lsp.buf.hover({
        border = config.window_border,
      })
    end, opts(_opts, "Hover"))
    map("n", "<C-k>", function()
      vim.lsp.buf.signature_help({
        border = config.window_border,
      })
    end, opts(_opts, "Signature help"))
    map("n", "gd", vim.lsp.buf.definition, opts(_opts, "Definition"))
    map("n", "gD", vim.lsp.buf.declaration, opts(_opts, "Declaration"))
    map("n", "go", vim.lsp.buf.type_definition, opts(_opts, "Type definition"))

    local has_wk, wk = pcall(require, "which-key")
    if has_wk then
      wk.add({
        {
          mode = { "n", "v" },
          { "<leader>c", group = "+code" },
        },
      })
    end
    map("n", "<leader>cr", vim.lsp.buf.rename, opts(_opts, "Rename all word matches"))
    map("n", "<leader>ca", vim.lsp.buf.code_action, opts(_opts, "Code action"))
    if vim.lsp.buf.range_code_action then
      map("v", "<leader>ca", vim.lsp.buf.range_code_action, opts(_opts, "Code action (range)"))
    else
      map("v", "<leader>ca", vim.lsp.buf.code_action, opts(_opts, "Code action"))
    end

    -- Telescope
    wk.add({
      { "<leader>f", group = "+find" },
      { "<leader>fl", group = "+LSP" },
    })
    map("n", "<leader>flt", util.telescope("treesitter"), { desc = "Treesitter nodes" })
    map("n", "<leader>fli", util.telescope("lsp_implementations"), opts(_opts, "Implementation"))
    map("n", "<leader>flr", util.telescope("lsp_references"), opts(_opts, "References"))
  end,
})
