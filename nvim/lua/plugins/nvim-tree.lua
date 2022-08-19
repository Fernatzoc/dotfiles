require('nvim-tree').setup({
  disable_netrw = true,
  hijack_netrw = true,

  diagnostics = {
    enable = false,
    icons = {
      hint = '',
      info = '',
      warning = '',
      error = '',
    },
  },

  update_focused_file = {
    enable = true,
    update_cwd = false,
    ignore_list = {},
  },

  filters = {
    dotfiles = false,
    custom = { '.git' },
  },

  view = {
    width = 35,
    side = 'left',
    mappings = {
      custom_only = false,
      list = {},
    },
  },
})

vim.cmd('highlight NvimTreeFolderIcon guibg=blue')
