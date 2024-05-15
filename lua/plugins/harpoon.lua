return {
  {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      -- Settings
      require("harpoon").setup({
        menu = {
          borderchars = require("config").borderchars,
          width = 60,
          height = 10,
        },
      })

      -- Keys
      local map = vim.keymap.set
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")

      local has_wk, wk = pcall(require, "which-key")
      if has_wk then
        wk.register({
          ["<leader>h"] = { name = "+harpoon" },
        })
      end

      map("n", "<leader>ha", mark.add_file, { desc = "add mark" })
      map("n", "<leader>he", ui.toggle_quick_menu, { desc = "explore marks" })

      map("n", "<leader>h<leader>", ui.nav_next, { desc = "navigate to next mark" })

      -- Navigate to marks
      local num_of_allowed_marks = 6
      for mark_num = 1, num_of_allowed_marks do
        map("n", "<leader>h" .. mark_num, function()
          ui.nav_file(mark_num)
        end, { desc = "navigate to mark: " .. mark_num })
      end

      -- Telescope keys
      local has_telescope, telescope = pcall(require, "telescope")
      if has_telescope then
        telescope.load_extension("harpoon")

        map("n", "<leader>fh", function()
          telescope.extensions.harpoon.marks({
            layout_strategy = require("util").telescope_layout_strategy(),
          })
        end, { desc = "Harpoon marks" })
      end
    end,
  },
}
