local M = {}

-- Twilight
M.twilight_auto_toggle = true

-- Neorg
local neorg_home = os.getenv("NEORG_HOME") or vim.loop.os_homedir() .. "/Documents/neorg"
M.neorg = {
  home = neorg_home,
  default_workspace = "todo",
  workspaces = {
    todo = neorg_home .. "/todo",
    notes = neorg_home .. "/notes",
  },
  concealer = {
    icon_presets = {
      basic = "basic",
      diamond = "diamond",
      varied = "varied",
    },
  },
}
M.neorg.workspaces = vim.tbl_extend("error", require("config.neorg.workspaces"), M.neorg.workspaces)

-- Set colorscheme
-- Use name of lua file in the `nvim/lua/plugins/themes/` directory to specify
-- colorscheme.
M.colorscheme = "gruvbox-baby"

M.window_border = "single" -- Options: "none", "single", "double", "rounded", "solid", "shadow"
local borderchars = {
  ["none"] = { " ", " ", " ", " ", " ", " ", " ", " " },
  ["single"] = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
  ["rounded"] = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
}
M.borderchars = borderchars[M.window_border]

M.indent_char = "▏" -- Suggestions: '|', '¦', '┆', '┊', '┃', '║', '▏'

M.diagnostic = {
  format = "[#{c}] #{m} (#{s})",
  options = {
    underline = true,
    virtual_text = true,
    signs = true,
  },
}

-- Icons used by plugins
M.icons = {
  diagnostics = {
    error = {
      Icon = " ", -- "✘ ", " ",
      Char = "E",
    },
    warn = {
      Icon = " ", -- "▲ ", " ",
      Char = "W",
    },
    hint = {
      Icon = " ", -- "⚑ ", " ",
      Char = "h",
    },
    info = {
      Icon = " ", -- " ", " ",
      Char = "i",
    },
  },
  git = {
    Added = " ", -- " ",
    Modified = " ", -- " ",
    Removed = " ", -- " ",
  },
  mason = {
    Installed = "✓",
    Pending = "➜",
    Uninstalled = "✗",
  },
  current_buffer = {
    modified = "  ",
    readonly = "",
    unnamed = "",
  },
  kinds = {
    Array = " ",
    Boolean = " ",
    Class = " ",
    Color = " ",
    Constant = " ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = " ",
    Interface = " ",
    Key = " ",
    Keyword = " ",
    Method = " ",
    Module = " ",
    Namespace = " ",
    Null = " ",
    Number = " ",
    Object = " ",
    Operator = " ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Snippet = " ",
    String = " ",
    Struct = " ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = " ",
  },
}

M.icons.todo = {
  FIX = " ",
  TODO = " ",
  HACK = " ",
  WARN = M.icons.diagnostics.warn.Icon,
  PERF = " ", -- " ", " "
  NOTE = M.icons.diagnostics.info.Icon,
  TEST = " ",
}

return M
