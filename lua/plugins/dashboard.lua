return {
  {
    "goolord/alpha-nvim",
    lazy = false,
    config = function()
      local alpha_status, alpha = pcall(require, "alpha")
      if not alpha_status then
        return
      end

      local dashboard_status, dashboard = pcall(require, "alpha.themes.dashboard")
      if not dashboard_status then
        return
      end

      local function button(sc, txt, keybind, keybind_opts)
        local b = dashboard.button(sc, txt, keybind, keybind_opts)
        b.opts.hl = "AlphaButton"
        b.opts.hl_shortcut = "AlphaShortcut"
        return b
      end

      dashboard.section.header.val = {
        "",
        "    .....                                                   s                   .x+=:.                .                                              .x+=:.",
        " .H8888888h.  ~-.                                          :8                  z`    ^%              @88>                                           z`    ^%  ",
        " 888888888888x  `>               .u    .                  .88           u.        .   <k             %8P      u.    u.                x.    .          .   <k ",
        'X~     `?888888hx~      .u     .d88B :@8c        u       :888ooo  ...ue888b     .@8Ned8"       .      .     x@88k u@88c.       .    .@88k  z88u      .@8Ned8" ',
        '\'      x8.^"*88*"    ud8888.  ="8888f8888r    us888u.  -*8888888  888R Y888r  .@^%8888"   .udR88N   .@88u  ^"8888""8888"  .udR88N  ~"8888 ^8888    .@^%8888"  ',
        " `-:- X8888x       :888'8888.   4888>'88\"  .@88 \"8888\"   8888     888R I888> x88:  `)8b. <888'888k ''888E`   8888  888R  <888'888k   8888  888R   x88:  `)8b. ",
        "      488888>      d888 '88%\"   4888> '    9888  9888    8888     888R I888> 8888N=*8888 9888 'Y\"    888E    8888  888R  9888 'Y\"    8888  888R   8888N=*8888 ",
        '    .. `"88*       8888.+"      4888>      9888  9888    8888     888R I888>  %8"    R88 9888        888E    8888  888R  9888        8888  888R    %8"    R88 ',
        '  x88888nX"      . 8888L       .d888L .+   9888  9888   .8888Lu= u8888cJ888    @8Wou 9%  9888        888E    8888  888R  9888        8888 ,888B .   @8Wou 9%  ',
        ' !"*8888888n..  :  \'8888c. .+  ^"8888*"    9888  9888   ^%888*    "*888*P"   .888888P`   ?8888u../   888&   "*88*" 8888" ?8888u../  "8888Y 8888"  .888888P`   ',
        '\'    "*88888888*    "88888%       "Y"      "888*""888"    \'Y"       \'Y"      `   ^"F      "8888P\'    R888"    ""   \'Y"    "8888P\'    `Y"   \'YP    `   ^"F     ',
        '        ^"***"`       "YP\'                  ^Y"   ^Y\'                                       "P\'       ""                    "P\'                               ',
        "",
      }

      dashboard.section.buttons.val = {
        button("e", "  > Explore CWD", ":Ex<CR>"),
        button("r", "  > Recent files", ":Telescope oldfiles<CR>"),
        button("n", "  > New file", ":ene <BAR> startinsert <CR>"),
        button("f", "  > Find files", ":Telescope find_files hidden=true<CR>"),
        button("SPC swd", "  > Load CWD Session", ":SessionManager load_current_dir_session<CR>"), -- Will remove all buffers and :source the last saved session file of the current dirtectory.
        button("SPC sls", "  > Load Last Session", ":SessionManager load_last_session<CR>"), -- Will remove all buffers and :source the last saved session.
        button("SPC sll", "  > List All Sessions", ":SessionManager load_session<CR>"), -- Select and load session.
        button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h <CR>"), -- | split . | wincmd k | pwd<CR>"),
        button("q", "  > Quit NVIM", ":qa<CR>"),
      }

      dashboard.section.header.opts.margin = 20

      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.footer.opts.hl = "AlphaFooter"

      alpha.setup(dashboard.opts)
    end,
  },
}
