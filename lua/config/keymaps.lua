vim.g.mapleader = " "
vim.g.maplocalleader = ","

local map = vim.keymap.set

-- Quality of life bindings
map("n", "<leader>e", vim.cmd.Ex, { desc = "Netrw" })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Write" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

map("n", "<leader><leader>", "<C-6>", { desc = "Jump to previous buffer" }) -- <C-6> should be the same as <C-^>
map("n", "<A-Tab>", "<C-w>w", { desc = "Switch windows" })
map("n", "<leader><Tab>", "<C-w>w", { desc = "Switch windows" })
map("n", "<leader>sv", "<C-w>v", { desc = "Split vertically" })
map("n", "<leader>ss", "<C-w>v", { desc = "Split side" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split horizontally" })

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
map("v", "J", ":m-2<CR>gv=gv", { desc = "Move block down" })
map("v", "K", ":m'>+<CR>gv=gv", { desc = "Move block up" })

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
map("n", "<leader>!f", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "Open float" })
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "Previous diagnostic" })
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "Next diagnostic" })

-- Requires a language server to be attached
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = require("util").opts
    local _opts = { buffer = ev.buf }

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    map("n", "K", vim.lsp.buf.hover, opts(_opts, "Hover"))
    map("n", "<C-k>", vim.lsp.buf.signature_help, opts(_opts, "Signature help"))
    map("n", "gd", vim.lsp.buf.definition, opts(_opts, "Definition"))
    map("n", "gD", vim.lsp.buf.declaration, opts(_opts, "Declaration"))
    map("n", "go", vim.lsp.buf.type_definition, opts(_opts, "Type definition"))

    local has_wk, wk = pcall(require, "which-key")
    if has_wk then
      wk.register({
        mode = { "n", "v" },
        ["<leader>c"] = {
          name = "code",
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
    local builtin = require("telescope.builtin")
    wk.register({
      ["<leader>f"] = {
        name = "+find",
        ["l"] = { name = "+LSP" },
      },
    })
    map("n", "<leader>flt", builtin.treesitter, { desc = "Treesitter nodes" })
    map("n", "<leader>fli", builtin.lsp_implementations, opts(_opts, "Implementation"))
    map("n", "<leader>flr", builtin.lsp_references, opts(_opts, "References"))
  end,
})
