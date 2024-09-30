return {
  {
    "luisiacc/gruvbox-baby",
    priority = 1000,
    config = function()
      vim.o.background = "dark"
      vim.g.gruvbox_baby_use_original_palette = true

      -- Text styles
      vim.g.gruvbox_baby_keyword_style = "NONE"
      vim.g.gruvbox_baby_function_style = "NONE"

      -- Use above settings
      vim.cmd.colorscheme("gruvbox-baby")

      -- Override default colors, and add new ones
      local config = require("gruvbox-baby.config")
      local c = require("gruvbox-baby.colors")
      local colors = c.config(config)
      -- Default color fields
      colors.foreground = "#EBDBB2" -- Softer foreground
      colors.magenta = "#B16286"
      colors.pink = "#D3869B"
      colors.soft_yellow = "#D79921"
      colors.forest_green = "#689d6a"
      colors.light_blue = "#83a598"
      -- Extra color fields
      colors.soft_orange = "#D65D0E"
      colors.light_gray = "#A89984"
      colors.dim = "#504945"
      colors.bright_dim = "#807670"
      colors.cursor_line = "#2D2D2D" -- Slightly lighter than bg
      colors.primary = colors.orange
      colors.primary_dim = colors.soft_orange
      colors.secondary = colors.light_blue
      colors.secondary_dim = colors.blue_gray
      colors.floating_window_bg = colors.background

      -- Apply above overrides
      vim.g.gruvbox_baby_color_overrides = colors
      vim.cmd.colorscheme("gruvbox-baby")

      -- Diagnostic underline color an style
      local diagnostic_underline_style = { sp = colors.error_red, undercurl = true }

      -- Syntax highlight colors and styles
      local abstract_style = { italic = true }
      local boolean_style = { fg = colors.pink }
      local class_style = { fg = colors.bright_yellow }
      local constant_style = { fg = colors.pink, bold = true }
      local constructor_style = class_style
      local decorator_style = { fg = colors.bright_yellow, bold = true }
      local annotation_style = { fg = colors.clean_green, bold = true }
      local field_style = { fg = colors.foreground }
      local function_style = { fg = colors.clean_green }
      local function_builtin_style = { fg = colors.orange }
      local interface_style = { fg = colors.soft_green, italic = true }
      local static_style = { italic = true }
      local keyword_style = { fg = colors.red }
      local enum_style = { fg = colors.pink }
      local enum_member_style = constant_style
      local lable_style = { fg = colors.light_blue }
      local method_style = { fg = colors.clean_green }
      local abstract_method_style = { fg = colors.clean_green, italic = true }
      local number_style = { fg = colors.pink }
      local operator_style = { fg = colors.clean_green }
      local parameter_style = { fg = colors.light_blue }
      local property_style = { fg = colors.light_blue }
      local punctuation_bracket_style = { fg = colors.magenta }
      local punctuation_delimiter_style = { fg = colors.light_gray }
      local punctuation_special_style = { fg = colors.light_gray } -- Like $ in bash
      local string_style = { fg = colors.soft_green }
      local type_style = { fg = colors.bright_yellow }
      local variable_style = { fg = colors.foreground }
      local variable_special_style = { fg = parameter_style.fg, italic = true }

      -- Text files highlight colors and styles
      local heading_styles = {
        { bg = colors.dim, fg = colors.foreground, bold = true },
        { bg = colors.dim, fg = colors.foreground, bold = true },
        { bg = colors.dim, fg = colors.foreground, bold = true },
        { bg = colors.dim, fg = colors.foreground, bold = true },
        { bg = colors.dim, fg = colors.foreground, bold = true },
        { bg = colors.dim, fg = colors.foreground, bold = true },
      }

      local hl = vim.api.nvim_set_hl

      -- Cursor, Line numbers, and Fold column
      hl(0, "Cursor", { bg = colors.foreground })
      hl(0, "MultiCursor", { bg = colors.foreground })
      hl(0, "CursorLine", { bg = colors.cursor_line })
      hl(0, "CursorLineNR", { fg = colors.primary, bold = true })
      hl(0, "LineNR", { fg = colors.primary, bold = true })
      hl(0, "InactiveLineNR", { fg = colors.secondary_dim, bold = true })
      hl(0, "LineNrAbove", { fg = colors.comment })
      hl(0, "LineNrBelow", { fg = colors.comment })
      hl(0, "FoldColumn", { fg = colors.comment, italic = true })

      -- Visual and Search
      hl(0, "Visual", { bg = colors.dim })
      hl(0, "VisualNOS", { fg = colors.dim })
      hl(0, "Search", { bg = colors.dim })
      hl(0, "CurSearch", { bg = colors.dim })
      hl(0, "IncSearch", { bg = colors.dim })

      -- Floating windows and completion suggestions
      hl(0, "NormalFloat", { bg = colors.floating_window_bg })
      hl(0, "FloatBorder", { bg = colors.floating_window_bg, fg = colors.primary })
      hl(0, "NullLsInfoBorder", { bg = colors.floating_window_bg, fg = colors.primary })
      hl(0, "LspInfoBorder", { bg = colors.floating_window_bg, fg = colors.primary })
      hl(0, "Pmenu", { bg = colors.floating_window_bg, fg = colors.secondary })
      hl(0, "PmenuSel", { fg = colors.primary, bold = true })
      hl(0, "CmpItemAbbrMatch", { fg = colors.secondary })
      hl(0, "CmpItemAbbrMatchFuzzy", { fg = colors.secondary })
      hl(0, "CmpItemKindClass", class_style)
      hl(0, "CmpItemKindInterface", interface_style)
      hl(0, "CmpItemKindConstant", constant_style)
      hl(0, "CmpItemKindField", field_style)
      hl(0, "CmpItemKindFunction", function_style)
      hl(0, "CmpItemKindKeyword", keyword_style)
      hl(0, "CmpItemKindMethod", method_style)
      hl(0, "CmpItemKindProperty", property_style)
      hl(0, "CmpItemKindVariable", variable_style)
      hl(0, "CmpItemKindModule", property_style)

      -- Window separator
      hl(0, "WinSeparator", { fg = colors.primary })

      -- Override treesitter & LSP capture groups
      hl(0, "@lsp.type.enum", enum_style)
      hl(0, "@lsp.typemod.enum.importDeclaration", enum_style)
      hl(0, "@lsp.type.enumMember", enum_member_style)
      hl(0, "@punctuation.delimiter", punctuation_delimiter_style)
      hl(0, "@punctuation.bracket", punctuation_bracket_style)
      hl(0, "@punctuation.special", punctuation_special_style)
      hl(0, "@operator", operator_style)
      hl(0, "@variable", variable_style)
      hl(0, "@lsp.type.variable", variable_style)
      hl(0, "@lsp.typemod.variable.readonly", constant_style)
      hl(0, "@lsp.typemod.parameter.readonly", constant_style)
      hl(0, "@lsp.typemod.property.readonly", constant_style)
      hl(0, "@lsp.type.parameter", variable_style) -- Parameters in method code block
      hl(0, "@parameter", parameter_style)
      hl(0, "@variable.parameter", parameter_style)
      hl(0, "@lsp.typemod.parameter.declaration", parameter_style)
      hl(0, "@variable.builtin", variable_special_style)
      hl(0, "@property", property_style)
      hl(0, "@lsp.type.property", property_style)
      hl(0, "@field", field_style)
      hl(0, "@lsp.type.class", class_style)
      hl(0, "@lsp.typemod.class.importDeclaration", class_style)
      hl(0, "@lsp.typemod.class.public", class_style)
      hl(0, "@lsp.typemod.class.abstract", abstract_style)
      hl(0, "@lsp.mod.static", static_style)
      hl(0, "@lsp.type.interface", interface_style)
      hl(0, "@lsp.typemod.interface.importDeclaration", interface_style)
      hl(0, "@decorator", decorator_style)
      hl(0, "@lsp.type.decorator", decorator_style)
      hl(0, "@lsp.typemod.decorator.importDeclaration", decorator_style)
      hl(0, "@attribute.python", decorator_style) -- Decorator
      hl(0, "@lsp.type.annotation", annotation_style)
      hl(0, "@lsp.typemod.annotation.importDeclaration", annotation_style)
      hl(0, "@type", type_style)
      hl(0, "@lsp.type.type", type_style)
      hl(0, "@type.builtin", type_style)
      hl(0, "@boolean", boolean_style)
      hl(0, "Number", number_style)
      hl(0, "@number", number_style)
      hl(0, "Float", number_style)
      hl(0, "@float", number_style)
      hl(0, "@string", string_style)
      hl(0, "@constructor", constructor_style)
      hl(0, "@lsp.mod.constructor", constructor_style)
      hl(0, "@method", method_style)
      hl(0, "@lsp.type.method", method_style)
      hl(0, "@lsp.typemod.method.public", method_style)
      hl(0, "@function.method", method_style)
      hl(0, "@method.call", method_style)
      hl(0, "@function.method.call", method_style)
      hl(0, "Function", function_style)
      hl(0, "@function", function_style)
      hl(0, "@function.call", function_style)
      hl(0, "@lsp.type.function", function_style)
      hl(0, "@lsp.typemod.function.importDeclaration", function_style)
      hl(0, "@function.builtin", function_builtin_style)
      hl(0, "@lsp.typemod.function.defaultLibrary.lua", function_builtin_style)
      hl(0, "@lsp.typemod.namespace.importDeclaration", variable_style)
      hl(0, "@label", lable_style)
      hl(0, "@text.title", { fg = colors.primary, bold = true })
      hl(0, "@text.emphasis", { fg = colors.primary, italic = true })
      hl(0, "@text.strong", { fg = colors.primary, bold = true })

      -- UI
      hl(0, "VirtColumn", { link = "IndentBlanklineChar" })
      hl(0, "IblIndent", { fg = colors.cursor_line })
      hl(0, "MiniIndentscopeSymbol", { fg = colors.comment })

      -- Diagnostics
      hl(0, "DiagnosticError", { fg = colors.error_red })
      hl(0, "DiagnosticWarn", { fg = colors.soft_yellow })
      hl(0, "DiagnosticHint", { fg = colors.light_blue })
      hl(0, "DiagnosticInfo", { fg = colors.foreground })
      hl(0, "DiagnosticOk", { fg = colors.forest_green })
      hl(0, "DiagnosticUnderlineError", diagnostic_underline_style)
      hl(0, "DiagnosticUnderlineWarn", diagnostic_underline_style)
      hl(0, "DiagnosticUnderlineInfo", diagnostic_underline_style)
      hl(0, "DiagnosticUnderlineHint", diagnostic_underline_style)

      -- Matching brackets
      hl(0, "MatchParen", {}) -- Disable style

      -- Rainbow-brackets
      hl(0, "RainbowDelimiterRed", { fg = colors.red })
      hl(0, "RainbowDelimiterCyan", { fg = "#98971a" }) -- Different to not confuse with string
      hl(0, "RainbowDelimiterYellow", { fg = colors.soft_yellow })
      hl(0, "RainbowDelimiterBlue", { fg = colors.light_blue })
      hl(0, "RainbowDelimiterGreen", { fg = colors.forest_green })
      hl(0, "RainbowDelimiterViolet", { fg = colors.magenta })
      hl(0, "RainbowDelimiterOrange", { fg = colors.orange })

      -- Netrw
      hl(0, "netrwHelpCmd", { fg = colors.primary })
      hl(0, "netrwCmdSep", { fg = colors.comment })
      hl(0, "netrwQuickHelp", { fg = colors.secondary })
      hl(0, "netrwCmdNote", { fg = colors.secondary })
      hl(0, "netrwList", { fg = colors.secondary })
      hl(0, "netrwExe", { fg = colors.clean_green, bold = true })
      hl(0, "netrwClassify", { fg = colors.foreground })

      -- Telescope
      hl(0, "TelescopeBorder", { fg = colors.primary })
      hl(0, "TelescopeMatching", { fg = colors.secondary })
      hl(0, "TelescopeSelection", { bg = colors.floating_window_bg, fg = colors.primary, bold = true })
      hl(0, "TelescopeSelectionCaret", { fg = colors.primary, bold = true })
      hl(0, "TelescopePromptTitle", { bold = true })
      hl(0, "TelescopePromptPrefix", { fg = colors.comment })
      hl(0, "TelescopeResultsTitle", { bold = true })
      hl(0, "TelescopePreviewTitle", { bold = true })

      -- Harpoon
      hl(0, "HarpoonWindow", { bg = colors.floating_window_bg })
      hl(0, "HarpoonBorder", { fg = colors.primary, bold = true })

      -- Treesitter context
      hl(0, "TreesitterContext", { bg = colors.cursor_line })
      hl(0, "TreesitterContextLineNumber", { bg = colors.cursor_line, fg = colors.magenta, bold = true })

      -- Mason
      hl(0, "MasonHeader", { bg = colors.primary, fg = colors.background, bold = true })
      hl(0, "MasonHighlightBlockBold", { bg = colors.cursor_line, fg = colors.primary })
      hl(0, "MasonMutedBlock", { bg = colors.cursor_line, fg = colors.secondary })
      hl(0, "MasonHeading", { fg = colors.primary, bold = true })
      hl(0, "MasonHighlight", { fg = colors.secondary, bold = true })

      -- Lazy plugin manager
      hl(0, "LazyButtonActive", { bg = colors.cursor_line, fg = colors.primary })
      hl(0, "LazyButton", { bg = colors.cursor_line, fg = colors.secondary })
      hl(0, "LazyH1", { bg = colors.cursor_line, fg = colors.primary })
      hl(0, "LazyH2", { fg = colors.primary, bold = true })
      hl(0, "LazySpecial", { fg = colors.comment })

      -- Alpha dashboard
      hl(0, "AlphaHeader", { fg = colors.primary })
      hl(0, "AlphaFooter", { fg = colors.primary })
      hl(0, "AlphaButton", { fg = colors.comment })
      hl(0, "AlphaShortcut", { fg = colors.comment })

      -- Todo-comments
      hl(0, "TodoBgTODO", { bg = colors.orange, fg = colors.dark, bold = true })
      hl(0, "TodoFgTODO", { fg = colors.orange, bold = true })
      hl(0, "TodoBgFIX", { bg = colors.red, fg = colors.dark, bold = true })
      hl(0, "TodoFgFIX", { fg = colors.red, bold = true })

      -- Text files
      for i = 1, 6, 1 do
        hl(0, "@text.title." .. i .. ".marker.markdown", heading_styles[i])
        hl(0, "@text.title." .. i .. ".markdown", heading_styles[i])

        hl(0, "@neorg.headings." .. i .. ".title.norg", heading_styles[i])
      end
      hl(0, "@neorg.links.description.norg", { fg = colors.light_blue, underline = true })
      hl(0, "@neorg.markup.verbatim.norg", { bg = colors.background_dark, fg = colors.light_blue })
      hl(0, "@neorg.tags.ranged_verbatim.code_block", { bg = colors.background_dark })
      hl(0, "@neorg.todo_items.urgent.norg", { link = "DiagnosticWarn" })
    end,
  },
}
