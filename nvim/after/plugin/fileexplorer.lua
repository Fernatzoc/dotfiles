-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
  renderer = {
    icons = {
      show = {
        folder = true,
        folder_arrow = true,
        file = true,
        git = true,
      },
      glyphs = {
        folder = {
          arrow_closed = "⏵",
          arrow_open = "⏷",
        },
      },
    },
  },
})

vim.keymap.set("n", "<C-b>", ":NvimTreeFindFileToggle<CR>", { silent = true })
